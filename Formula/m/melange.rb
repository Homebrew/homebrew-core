class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "cf21ca74b65b01ce11e5c02df589e452842d61f48d575c8de2caa06d4d53bb2c"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcb1f255b3a5353de3a4a44e1f83ca8ec574e97183862bc1e7c3a29abc01b466"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f029c84c7bc2393d52a775eeeef90208488aea2ba40c5e55dbf5a9a6e15fc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ced297f9f885d94db7f5e91b0d67876f4ccb574859e117425c0a5d0b3823556e"
    sha256 cellar: :any_skip_relocation, sonoma:        "771a5b304f2cd5f1c3069fa34d873944f78f80ea50709b30eaf19b76f592abf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96da6a018aa4da1890c5653190a1707fdcf41e3cf024c7fae3506c5f651eee86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69001ec64959e509457a58796ec3e719bf9f56bb353529ce4717ec67636e0a15"
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
