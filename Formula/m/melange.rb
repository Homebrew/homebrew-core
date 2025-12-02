class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "c8956c0fd6e6f554f627af6a781ce66e1086070b80a0d6206f9fef68d46b3560"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27aa2583f2054d0434f92beeeb5ee9973c31e7f971beab9b7c866b76ff035228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9b0e362b4e606d8fc49a92abafe5c26646e25dadcc5d92b8c3675dcbf7f0ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41b7971d9a3a6c96d2f7f50870274e2d699013ab02ce1fb4bf6887f22b2f0a5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "020625f0f75aca44758d929227de8058203470ad07578759b50576e3ccc76cee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9c15ae8ca667e021fed0c750fc98a3dbf3478af012c3d428d2f599bfe70f802"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68f8388984f13cf74f67c3a2d38b8700d1a04f2fbad4a13b2b7169f900ec2fb7"
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
