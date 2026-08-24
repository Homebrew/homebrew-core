class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.59.2.tar.gz"
  sha256 "d2a0a2a727e9196909ced0d4af22201ded7ec950288e327ae3e449fa10a40241"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2f9f4aa8566796a8a7d650d9225c02b6db950479348b5500f01364b36f01ce8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8bea669faf46db815edae6045209df502fe03752eb6e40051e0ff42a3be7f0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f918a8195d6365bb861296ae5aa429785544d97c5e41c643faf86046cac34f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a05a796296bd4e290547726c84706f5b0c0a6361974ac3ced427a3862db7cbc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ffb59b6e74ded588fb7fe8a7ae83e21c3f71d5fb3db2850404d182fef9e1bc0"
    sha256 cellar: :any,                 x86_64_linux:  "96aec6ceec75c6dacb80fb7bdc1d168f467e07fdb724b3abf2331d0f0416a071"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
