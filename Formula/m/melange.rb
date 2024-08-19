class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "0f35c60494aad31160e5ff84f8bc228c38284e0d896333d9063dbc43223fdc61"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c1305c88d4dc8f0383d238d76f71765f0010ea4c6218f6e374dc7a586f15d83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "270e6714f6bce6756d10e8217857d34adeb5adccde4889e921f618aec332995c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcaeb31b99a2e8c81281ad5f2c18ed1a69938c8e5ef3551792df5f118e49ca9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f34d41715bf3b128985d0d46e98bf5235e492df0491fd82e4e077b14bff210a1"
    sha256 cellar: :any_skip_relocation, ventura:        "35561e2f1e8d2818786115be00fdf6b57d0e43ffd0282f3961ae8359ce96ad56"
    sha256 cellar: :any_skip_relocation, monterey:       "c22dcf01dad98ca5c6009b7fbf59b88d73bff119bdb34367b0655a77e7b821c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f11dfeccb903b8874f96846b77185888081f4ac7e9bc9b3e1d8454a884271a3f"
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
    (testpath/"test.yml").write <<~EOS
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
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
