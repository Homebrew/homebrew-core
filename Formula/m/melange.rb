class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.26.11.tar.gz"
  sha256 "9b939d948fdd52643687e2d2ef0c6deb397809b211a8d927fef6145c0a3cdcd8"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc99156385ec67cc5e6450e1c084a493f10baf6edc80b447e0a0c1dbb9e066f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa715fd4739ff4cbb94471c069c393948e448c5ed4577c20eb5dc917111d9da9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8871b90143171a20c7f8c9867776df3e8712b3d9bf846660832d1394f4f46974"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fb5b98b3cac0e11a008ae74d08b479a4518c130e1871ba2228942f26b991e90"
    sha256 cellar: :any_skip_relocation, ventura:       "4c0656892f574f22a2b8ffd37d14db7316752e4c40100bee5fa5fb4d7de48709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbe4348f4dd2217de6264f7fad901b37f2e71b9228de20a0b383efa2fa1b95bf"
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
