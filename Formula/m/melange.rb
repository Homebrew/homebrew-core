class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "df809b028d4495f51e23c1954811d79cc21d19aa87ba6a01b14af85fcb8d0ce4"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97b181410b365e4cc81da6ef7c0ee264a3333917faa8543a14e6727b39ca6f08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "366d53bafe18237add07ee641cdeb4564d44facf065eb6f23dd0214eca4acdf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d592f2036e9c6e853e22f1011081af93a2dd4ac5f72859b99dde7163da61abf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "74cfd6ae89fdd8b757b310f27e57e14708dcc10ff6f1fd43703b7be33be808a2"
    sha256 cellar: :any_skip_relocation, ventura:        "e0a6de5952c792c058fcb823d7d35af47465dbf47793b72c004dcc3ab3dff4b9"
    sha256 cellar: :any_skip_relocation, monterey:       "923e5ff2b72d449f209baf83125130928ec014f68fe41b82f7cebfe7b287bdc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc18a3643bc74b8c60e1eb364104b1709debf6cc06f00350739afc335d2de2fb"
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
