class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "d15ab71cdd4c239796ff44896439e4d1608db1da867406ddfe695e2184083b6e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "d9e9fdb8eed93311b6e426b8b70f2cece3d8447f513a5cd7460b4bd8e40cb98d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82b715b97316685c228b0997fe21bc32b2dd8fa9ea8784e0063413e0cd788787"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e486bb502146377cf7cc2b84728ca9f1a494e60865ecd9d84aace94dd30ce94b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "debbbc1094164ecf3901f471b4ca80162975cbe4239672822cfeeb2a8c2f8e83"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "769773daff0f99f5d49e041d691dd6d80628f8f970d28f8140ea7244343732e4"
    sha256 cellar: :any,                 x86_64_linux:      "2edcda1b82fbe7cbaeca7945de077c2278286f5a0254a488212ba3a9d8d8c0bf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
