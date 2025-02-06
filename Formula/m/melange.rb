class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "710541c9f95dcfdb47a3e6045e5b4d72f6e1ed40d212dbd01b4a74b8cbd94d16"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d642d8ad958def7a7e40bc9c762724f78ad1805092a62f0109358a261719dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45d642d8ad958def7a7e40bc9c762724f78ad1805092a62f0109358a261719dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45d642d8ad958def7a7e40bc9c762724f78ad1805092a62f0109358a261719dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e118af847812c6403509a1286902914f394c0438a8676c95bc3321da962443e"
    sha256 cellar: :any_skip_relocation, ventura:       "9e118af847812c6403509a1286902914f394c0438a8676c95bc3321da962443e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "647f5cec6bf337a97418153ebdf081791f040abc28b058e050ae7a1b252bca5d"
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
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
