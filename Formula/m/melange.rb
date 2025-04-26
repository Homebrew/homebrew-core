class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.23.10.tar.gz"
  sha256 "ac0a20e1b6b99199b845f7b09f3bc89135fb9083836f555e4fe1d699262fb164"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "102447b295d4bb247324bb741300d640ad2adf5f95549e0037395d8eac3cf083"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0695a68b9e4a937f2a8edc2214b2e6f94a52bd7d7831085e86a7d30efa94b0d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62ced2c662ad54d911ace33c0afdb129ed336183571eb68c957154aed28ca507"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ffd41f70ee19303ae4b793f5af74b81db02c99c660c63d9db7fd6b3bbbe8a01"
    sha256 cellar: :any_skip_relocation, ventura:       "57230ca95230753a8a37e90b287618f362fb37a6de5a58cd0ef498a9b993cee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "711db660c4d970a976af3c23e31ebc70dadca9784dfdb100101dc6edca7b7c06"
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
