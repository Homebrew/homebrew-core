class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "60ed05b4451f946dee2bb5a5b8fc7fbc528f6e9c5d20d63e2a870b24cb985595"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc9c9f6b66afe46447038ab515ccab9ed3aaf45bb638a52014c5f64ca8ca407e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b7f3578e9951a6cfe53a6a124367339fb0440b05316eb517a8f215b98e93158"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ab3058145f6258d106ea7cc188ce991850cdba2b1ba01953b9af6c77d43e2d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca4710e554e656e4d82139a57b4dece0967300172b1c1bd42b3dbb772dd32b3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2f1a82d50efbbcfbaabfe58f6244dde285cee26062a8fb0a7c7f21a233e4ab8"
    sha256 cellar: :any,                 x86_64_linux:  "ff779cd31ccd35118725b244eddd579033051f880f1530d67597b70885c73e09"
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
