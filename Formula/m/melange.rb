class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.5.tar.gz"
  sha256 "f9ece55f008552768b805073f043941c1aff17144d00abb668cd2a616c677292"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a97643c2d37640c515edc155c8e1f4fe68bf243d37d62f46089454595fa0a2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89cf919e861d9d1c9f59f62992e86e1dfbd416bde0d8bf390a04eaa737909686"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a0635227582dba57b852f3923ced6beeda6dd3fce4c4981f9043bd0b0f8717e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1297cf4f1b7ba4d9bdca4a4dffc39dacdce8ed211ebe56e81de0add4c8d60ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adaeb66a5faf2ac87c7cf05b8cd64d612dacffe30a95ea2d0e3ecaba83a11b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d712df37391a87a451c0e12eb335be1f2dcfadaf88313d17527c6737fbd1a022"
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
