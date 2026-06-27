class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "9c8032f18f3927518a55bacdbdc29e2276f50d0c3713727f3de8402a10d3f08f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6ef0b3b29277138329d72e12f9f15ecc309c4e5dcf2de521e8d58c6fd62b285"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62a538539e8259a7ad583f6a8ab18a6972999f4d3252df3607c103f77cb22a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62561c48b573e36a73ee46b52384995cc5e21d590e1c8cc4ce0a3760c58c0105"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a7afe58b4295daaaa0c98ee9a002d88948a8b5f617df4e6b99a01bcaee65044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b44eb1c6883f7e4cd58c07f88e8d7e2355a129b7862a8a9a671978dcb452c3"
    sha256 cellar: :any,                 x86_64_linux:  "f9d62873b66614133a7f75297da9ef368fb80b4eda3c9f52eea297632c08ad61"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    YAML

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end
