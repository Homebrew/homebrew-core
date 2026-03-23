class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "123f230dc5a0af77df162923ef9933cef03ff290f6cbe7f9ed9ad8ef5e3a4e4e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4f57092050eebf00a56f031716094eb9ad090b2a5a2f07e31f38064f0e04c6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1804fa7e0aeb38be1722a4cf973226d71a07ee0be6f561162c30432a47b21c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a25854e579880bbe087875e243324551113e5c02487081434b95a6c9ddefbf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3e862adfb407a9137201f3ad29e7abd23ab15830d331e470e336e88198e8d61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4e2c1c564e3596c93a9dc1094c7f501778eda96d74dea49c80d09c66c7e940a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c62ca944d6c925a02ce12b08c877b71c7fbbec41227ac189b875dbd4747e3e2"
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
