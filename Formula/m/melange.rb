class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "696a4772258e1f7d5c47e96ad4d46a235775f1aac21d5457d41e254555e44cb1"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe90e3eb062ca692d72406362420af9b833f3c596ce74f3eb766b26a0d4b5d1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ebb7fb92841dbe7210776ca02d3d3eb0d35b862b8bcd620df9aa34dccd30a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "682b5a144fda822fa68b7794f2d325f87b492be21c31a3a7d47c47a223b6f230"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f4499c6b919bfe64c961de507291f90a0bde9c53f7739057df4b4c3476a28f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d15ca79d754b195ad3f3ee44f2e8245c9d4749cbbe8708ffd424c7f25f14110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4025ab9c33e164f57488601023f5c6e99f138ae38298d1c9ea457449d2228f1"
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

    generate_completions_from_executable(bin/"melange", "completion")
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
