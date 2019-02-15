#!/bin/bash

set -e

sudo chown -R $USER .
git clone https://$GITHUB_TOKEN@github.com/Homebrew/formulae.brew.sh
cd formulae.brew.sh
git fetch
rake
