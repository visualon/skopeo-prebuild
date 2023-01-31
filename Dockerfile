#--------------------------------------
# Ubuntu flavor
#--------------------------------------
ARG DISTRO=focal

#--------------------------------------
# base images
#--------------------------------------
FROM ubuntu:bionic@sha256:63986ce572d0e7b2268073c863561cb001ef3cb15ef69c45c1d890f7262e1bdf as build-bionic
FROM ubuntu:focal@sha256:0e0402cd13f68137edb0266e1d2c682f217814420f2d43d300ed8f65479b14fb as build-focal
FROM containerbase/buildpack:4.17.0@sha256:8568c5698e4129f2ec1f93df6dbd3298d069791f53c5744314fdd9a8dbe7d334 AS buildpack

#--------------------------------------
# builder images
#--------------------------------------
FROM build-${DISTRO} as builder

ENV BASH_ENV=/usr/local/etc/env
SHELL ["/bin/bash" , "-c"]

ENTRYPOINT [ "dumb-init", "--", "builder.sh" ]

COPY --from=buildpack /usr/local/bin/ /usr/local/bin/
COPY --from=buildpack /usr/local/buildpack/ /usr/local/buildpack/
RUN install-buildpack

# renovate: datasource=github-tags lookupName=git/git
RUN install-tool git v2.39.1

COPY bin /usr/local/bin

# renovate: datasource=docker depName=golang versioning=docker
RUN install-tool golang 1.18.2

RUN install-builder.sh

WORKDIR /src
