class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "816ab338c54f695edca0c0da24c9e41110535bb904e1d0801d2ed2609e778f08"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a38ce0ca882588d3016abcf0aa3b0a1d0e3924ce8418040a1c18820e78e96d2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad6c7acb263560a1a439f176d38a96fee51f2e365d82f5ec2c302d0aea968ff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e52550a2af1cfbf3f2c821d3a6e308b02265d3e6f08579a54b61d7f04b1d181"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d0134f61c96dfd3b665889b148150a0611369c03d6887e8d4fe176c7c79d63d"
    sha256 cellar: :any_skip_relocation, ventura:        "d4de9d3315ae4fe73325b748b7a608de590d3d46a7d86240415fa535f77fb785"
    sha256 cellar: :any_skip_relocation, monterey:       "eb6aeb2f924c2cad93b24296b989b212d2f6a0b08d67c9dcf50a8d6da03164ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "254c5c2cc5c2205befb30a214848cad9318d6212500b17b79037e4915ad29960"
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
