class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.45.4.tar.gz"
  sha256 "b6799e437c114a400683fa09d04f6f72029391e1927b69b00c0af8abe38ce46e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b421ca29673b909103e6f4e6138f54eb16f5af75ebcd9c88887cac92828efcad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74392e62795815e4f6094deb81432a196616b40f75f000dd1a22c986c4195806"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2196493dc454ffbeede1604cca51c61d81d2e6a4ae1c171046275322868634f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6db4a09aa63055254a17207a5958be98ed6f5ebcc7fd38193bf595be01b4f9a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7da59ae98ad7048c739c59085b0936f1d1d368482b6449645ae39d8556a2e3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6747f8c839bc8350a944177320621fec99a592310901d8091d5760d9c1d1921b"
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
