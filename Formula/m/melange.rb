class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.6.tar.gz"
  sha256 "525e063ba0b40af70b652c15f3abb65295a5b3d04d74577ad9ae1a49a459c051"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46f1ed7c2a8e98b1d49ab77ae2f0065b86a30b0b6b1b9a3d71ded504504dae55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61b4c605d45efb195c571cb295f8d563d83fb09bade1c6ba2332f67863fa744f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bf5d4bd90b48361357e74a40e5084e0933ced7c0ea07b8e6bfb9d46b2a591f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "12570e1de24e8e3e636aa263a8310524cccf45ad4b7dbada3b5c698b35be4892"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e19ab1fed6ac2394803d9be14c668249c696761fd8e909361c367b7ad68dd0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77f0616384d77c17fe578eb01740b288c42cd42cc6deaf4d61e6401ff2113f95"
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
