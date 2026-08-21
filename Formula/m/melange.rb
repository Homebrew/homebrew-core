class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.59.1.tar.gz"
  sha256 "68fe70ae455c39a007bec7ab4af7f4276e00ab70fad201f9dda2276ab3911b05"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8201e304193a779a921ec917e042a7edb7ca185f536c8966c6ba8121e389ef86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77709916095cb9271a8c9fa3a549704cd19d730f5a274beaff515304ece92fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea573d2079306ebd6ecabf21d9dfaf15320b268bec3fecd0d7aaa994b363364e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9b59b3563fa4b700f36cbd4d84683ea8974ffb2c5eefb014e0a386762fafba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e97079fe686b35601e6623762d899867425cf00b57cadd067efc81c63f75c31"
    sha256 cellar: :any,                 x86_64_linux:  "db4caff6a03e3fbf0072dba9f61a5fb505a719cd04049ad52abcb4461ad2b20f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
