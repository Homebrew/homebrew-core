class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.23.14.tar.gz"
  sha256 "1d06eee2e031c975fe4d19de0ca713d81e5a8e8f2f119cf59547be1affdf246b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86a4d078238041a7b6ed316b688aea9ab7aa730760456ca146947d89af156a0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cddbf640abf95e85d02094313ea7522b4cd09a6b58c0a95ff6428dbecd1df812"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86899dcd54e9006d93a9eb817515d1597b028436886909808b1fe0d07a8cea64"
    sha256 cellar: :any_skip_relocation, sonoma:        "930de7de3cc3ad0eec3f534d49d04aa6485afb3a0dd6dd10e915311d2e8da1fe"
    sha256 cellar: :any_skip_relocation, ventura:       "5407ebe5eb60d406665d1c65013e949d5d976efaa4f5c4c31991788344048321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8388e517aaa6c091a143211909f28559632d8c7b87078462ccfb4ca5d5874d20"
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
