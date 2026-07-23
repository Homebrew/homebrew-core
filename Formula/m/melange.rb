class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.56.3.tar.gz"
  sha256 "cbb3936c805289c5b8fd0b37b4ce99cd465ced2b59dc48a3b1debb19675632ba"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb1a61ad09933f0a21d68c3ccfef695e1254259b2579f5adee19fcfabbcfd33e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eb07acaba0323d76cc9756a0e678c1cb9f23bad6626fcf7bda820fddd780251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be54a9ea381a903f622feee90c0bc3bc3c9a6af951bcff6428c2263e5de9464"
    sha256 cellar: :any_skip_relocation, sonoma:        "1defc7d3375f5751c3ea06b96c3d62b79069a0797f33a5bf4bca88151aa4fb8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a078d633017e3dd8577e92dddf61e23bb67f49dafadd9af745fbc999096f5dff"
    sha256 cellar: :any,                 x86_64_linux:  "c37a56fd65c5006543a8a856fb60103dbdddb1b17871a14f3c964eeb25fc6d09"
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
