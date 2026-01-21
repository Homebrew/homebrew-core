class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "185c80875503ce690493ed4bac4bcb9ca6c966d7b6551258506519f00c31003f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40b69148f790be6727364c1e27f4748eb0cc1c41ec03539aa6f30a346972e248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75a178d708a8524d4ff62122deb6f12a15155cd3872c8e776206d63d9bc07efb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "144186b9e5d91907bc27eeb1645212dfba5f873296133fad86847ce91888433c"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab859fa8dfa84172f442145123c6b25bd6125f25b7089b55f29e38d4b08fd99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e11ee1de30be1560cca51afbb664efa0a2adb07e30a8d1f27ad891b503e04a78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d3a5a5fa2fe17902f8dffcbb6aa0325d2d673fb2a8a0f899a1745eaf8d342b0"
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
