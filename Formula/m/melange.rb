class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.26.12.tar.gz"
  sha256 "9c9476491a58f22528af57f30ac614f6454d72bb2cc6df9a6cf716e8211560b9"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5347f80492c6e153c90b2321dcc65d6c12b7c1d3c59c5426a0470860f2091566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "341628c88218379b80450b5ab6091fca98af83a949ff418ae656b3fdae2c2a7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11fa364b42b11fa67bd5bdeb20bbf084808fa90ba59c018e76a4d3b647fcb3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "43d1076664ecd780aa0c442822286db9ddf884ff2caaf3f3cf7836bbf13575d1"
    sha256 cellar: :any_skip_relocation, ventura:       "e19860fcadb06e5a659cd79e2d0fb1a261541716ead65970f6af5ed865f45ddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f69bf6a6779e80972c2b2205bb04f03116c1895f42a639d86c65f3c0c32195"
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
    assert_path_exists testpath/"melange.rsa"

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
