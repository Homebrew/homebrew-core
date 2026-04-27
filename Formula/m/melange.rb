class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.3.tar.gz"
  sha256 "bd5ad8ebd58d29b17eceee66e3bd64bea5c52363ebdb591f1db89cb0ebd48aa4"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dabae9049058c1048754d8fea35762e3cb550364107111d29f550e3ed67ba77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec4e9d9068b0ba2f56df6f7b711371b63233009f57523e7ce21e8fd84224cf57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa710efcdc3e4be82e502ccc25d6a555a698c27a5aabcc4cc3d6f97b6f1e921a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bee7392607a443d7e80b8d6f7948fafb4839fa54b2d708a6771263601da6a7d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c235f6675b4906b6c2ea403ce90141b8c90d2e677089a5fea546648fc163d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0775d9d0c2c9cdc1e24b269b93bbe4e00fe16077fe473cb08cb77b7860e2aa"
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
