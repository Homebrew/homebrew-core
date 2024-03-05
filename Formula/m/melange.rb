class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "b53aec766113fa77a985e63b6cf784bc838b64658c89189eb547c2f571bf55b5"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31ae76a5e05c3835ce60ad71a86aa7b8ac4c9bd98d9a2f8807c7f2352704742f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a184e4252e9741a77147b1c7506f93f7972d5d77261ee4eacfd57fba712b8030"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "445b3dafb111babc9c8058b32c8c8461ad779a4199594acf31e85ac95396975d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3717bf76725f0fe2a724e538cb5021f6ad5745117587b1acd61cf08fed652905"
    sha256 cellar: :any_skip_relocation, ventura:        "2f36f137fb46ec4f114583946932d3a9e76c4f81265c53df562473a9b9f3686d"
    sha256 cellar: :any_skip_relocation, monterey:       "c363934db6050c53251c549f2f046d966d5b03655c181b84052c1bafacb99eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fd07dd71062510537eb16aaa4b34558345c1f1d374b02ed3d2b7d93c41a754"
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
