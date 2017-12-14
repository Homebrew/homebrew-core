class Circleci < Formula
  desc "Tool which enables to reproduce CircleCI build locally"
  homepage "https://circleci.com/docs/2.0/local-jobs/"
  url "https://circle-downloads.s3.amazonaws.com/releases/build_agent_wrapper/circleci"
  version "0.0.4579-9c6473a"
  sha256 "2db865b97d490914e7fb6a056f94d80b1cc9e3b2ed9c09723b529d673c131d7a"

  bottle :unneeded

  depends_on "docker"

  def install
    bin.install "circleci"
  end

  test do
    (testpath/".circleci").mkpath
    (testpath/".circleci/config.yml").write <<~EOS
      version: 2

      default: &default
        docker:
          - image: python:3.6.3-alpine

      jobs:
        build:
          <<: *default
          steps:
            - checkout
            - run:
                name: Install build dependencies
                command: apk --update add build-base
            - run:
                name: Install python dependencies
                command: pip install -r requirements.txt -U
            - run:
                name: Install python test dependencies
                command: pip install -r requirements_test.txt -U
            - run: make test
            - store_artifacts:
                path: htmlcov
    EOS
    validation_output = shell_output("#{bin}/circleci --tag latest config validate")
    assert_match "config file is valid", validation_output
    assert_match version.to_s, shell_output("#{bin}/circleci --tag latest version")
  end
end
