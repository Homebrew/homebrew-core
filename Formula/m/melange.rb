class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.48.2.tar.gz"
  sha256 "0022807002def8835c9dc2add4526df305996df244aa0d225c9235664c2e73a1"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fe25cbe10609fa63b781556966ace76fee6d06bda8756e82ec03bf91773096c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e29a69bc2f9ef0e02847f3bfc4ed70a1eef124157f5cb4e5ce609889e1524f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cc2a5d6a6160d1311582c706e3da9972b3a95c495a01557fdc8d64546e71f4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb42d39279692911527999e4f7674f7527cda545d89fb5e8780d62fbd25a768b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed77192ddcf466d335e551523fc9d5fb40db70ba251c7af6f2b4217dc2eef162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83bc9822521734eb500343e96ae440588efab9eb107c21c94e7acc9609df32b"
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
