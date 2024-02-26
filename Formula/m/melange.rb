class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "7a5eca716d123782b5017b629440d3da15c5ab134e35f8f00125226a879df99b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eeaaf751f365f382951d0d9c24d9fe418ace23614fbaec1b78bc1c3a02156b2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2a3a1a398345ff8af230283895422f344694b2c3cc4184757148ea1edf18c45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c94d2c354357fa5f2838184d925b560743539d2673a298e00de1448ba0e8aa9a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce1fb8acc0b1860b1019e2bf3556f2c24ff8305790217632693a9224557741fc"
    sha256 cellar: :any_skip_relocation, ventura:        "c8e667f6d6944d99789020dfddd01d4921899d7dff43e3976097c2c481c98ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "0150ef26092d8461b4cfb463fb564617ed05906f0be56f9dab21836579040dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "820893381540dd1cc537637ffeacd91782031b8ae6cf63a02f65b68cf66cc0aa"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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
