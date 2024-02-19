class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "1544ed21f2c5ba750654eaefe870571f055b3e71fac2bee31d306d6b366193f4"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e74a8fff3f3f2ed345b05a2e90b823dc54eb15a46d323abca7ec744d573dc74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3870c0e0c6d8ffb99caf2468937d51891a096b0bbd50747a27f145e1f73519bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ad2efbad9829de19f36b547bb69cae19029e2e1c766956b28a0877e0d8d412a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dc4c03d7553ab09df58633502d583294567c361fefdf6118142edab0ef84425"
    sha256 cellar: :any_skip_relocation, ventura:        "257561f2a7321f19cb12bf788268bab6e6cea50899e13a3c7aea4983ce6e8813"
    sha256 cellar: :any_skip_relocation, monterey:       "909153568efaab84fc04d563d533cd1c5a847f32fc8e47c6ea435532d214b5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9248731824bcfc943036a7e89bc42240fd18e2e61cc9babf60e1699adc6863e8"
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
