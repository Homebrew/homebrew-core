class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "b53aec766113fa77a985e63b6cf784bc838b64658c89189eb547c2f571bf55b5"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80eb88c63754ce970a6f9723f4608a55db89ff04e700fc6ccaac66ab97b3b46d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b6c38815b85676d947a78c4e8f09709ce75641581b4f2198a01c176b8b5792a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47b5c78244e0dc56cba77f48ea8503126ed2697fc705395777c548b3a815852f"
    sha256 cellar: :any_skip_relocation, sonoma:         "50f9fe4eacff15f5abe385c138bad4fe95c5189153fdc3baa20f1eb8f7d49e3c"
    sha256 cellar: :any_skip_relocation, ventura:        "919f901ca4bd20b65d0d7866630d7d59c8099e858f6b00bccf9918df0c39b22c"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7fd90e47ae61f468b24459ea0863e3aaa09724348ab3ea7fa467c9cbd5b636"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4e08f37fe2179a699d3c0cad1e4f256779f65673df35ee8d398912d50d3c4f3"
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
