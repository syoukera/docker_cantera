FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    libboost-all-dev \
    python3 \
    python3-dev \
    python3-pip \
    python-setuptools \
    scons \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/bin/python3.6 /usr/local/bin/python3 \
 && ln -s /usr/bin/python3.6 /usr/local/bin/python \
 && ln -s /usr/bin/pip3 /usr/local/bin/pip

RUN mkdir /working \
 && chmod -R a+w /working
WORKDIR /working

RUN git clone https://github.com/Cantera/cantera 
WORKDIR /working/cantera

RUN scons build
RUN scons install \
RUN /bin/bash -c "source /usr/local/bin/setup_cantera"

WORKDIR /working

RUN pip install --upgrade pip \
 && pip install \
    numpy \
    matplotlib \
    pandas \
    jupyterlab \
    setuptools \
 && jupyter serverextension enable --py jupyterlab --sys-prefix

EXPOSE 8888
