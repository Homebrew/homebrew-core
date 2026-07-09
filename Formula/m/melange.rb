class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "53ed06cc6cf0cb2ae520377aa99ad3bec73d263b3d500988c62f9b78e1ec3eab"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf7b48c5426cd2aba9892c27faca0335081759138e21aba7d4cc24ee0018aa6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f3ea2f5f5aa58930a72ab186468bccc13a65ba383293ec9c86f37bb03019d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ea4ad431317bdb1aef0971812b6d30dc837ba38a38c817032907105a82198e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8290b99b2211b44319e9327ce73e4766ccb0e681803f5aab2195d69fff6a5d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60802bcbe2f05e3557433884fc0afa68d15b84812221d10a0243fc2fe85984e6"
    sha256 cellar: :any,                 x86_64_linux:  "7bd019ed05c0cf06599a8a09a20aace78101eb660b9bb5af3ddc135904dc684a"
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
