class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.23.5.tar.gz"
  sha256 "0fedfbb3aca2a44d74940e13f17160e7c0e8ed09774aaf8377999a28163b1028"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2637351c994cf4fe0f501dc8fcff300e68202fb84fc1e029c9c275ab05291a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "344ad1809dda311c26d59bb015efe87fd9343ea8fac45dabffe30b398e5d6253"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56a77c151d069d90f4756cea60471c546128f43dd3f76d050473aa161a4c014b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9d42cbbc7826f8f4857467e25524500b194454763d9d3eef33d434d01c31857"
    sha256 cellar: :any_skip_relocation, ventura:       "55c9d4a617fc1f2638635e7a33cbc50df5b32f80e0c56664f5434e644f42c168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "571a0c910f9b39bff4610dcab8de72624a9d29e2f4d6ab7330c6da008828b083"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
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

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
