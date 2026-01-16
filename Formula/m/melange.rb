class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "9446bdd610b25649cc77a86db587e6bbc0d683765a05b762e9c0614eda1ac087"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ee69b5423e60458a4ed9928093e14ca386759a169e24f524887e00cc1db571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90e2f7917e26a14bda11df35a78b6221dfbe4c36913eda6c1bcd56000f6079d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deeed52929e8c8cdb09568bb7ee3e7a38fc4acad752e85190b6c8d92ebd5d3e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ca422fd59bb4a76fdc9e8a987853000f989990f11b33cad7ab234a8946aaa1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "628100547fac8e46c35c198c4c3be65de6cbde7fa6cf0f6e0f208ba29f661638"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "819cfefc81334aa6b87642beff2ee76b65657ade97bd91a1a2aec2ba3d06c2f5"
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
