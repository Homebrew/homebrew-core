class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.59.4.tar.gz"
  sha256 "5dcfbd36e8629a5e66dc56b281a32bd4187b7f41149ae041a427b461a7131e4c"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2116dd0282c780c04b3eb3ed337213d9ad5a932416c1d531c132ad87356fd39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3b75ffc78f61a8b0030cbd35f810ae285836f7959067f78eb22229aee19f4bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59cddfa34e8a9942c56ff93a2d29d786e5902bf27fa8fe45ab1d53247898488a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "994c85066ca3d7071217113b41631ef7b3ffa6c5632d9b4b79c4252aef68d5e2"
    sha256 cellar: :any,                 x86_64_linux:  "49da6ecd41ad1da3981ce80c3a9db5fbc95c3dd895beea602f39e7ab2ccdf5b6"
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
