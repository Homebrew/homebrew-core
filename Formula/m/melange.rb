class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "feb489f5f39f1691e599ceeef9a62e302630887bfab8da0f7c75dfb3e4b0f4f4"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d70907bd9051dcff60bade93fc50b4e6536b02cbdad0f58a4fc2d1b9f65cc58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "988d12d4f01f5b5f732959b8b89308b815c539c754627deb958fbc0f2c6bb2f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a5eb7bf26873d50b2619afa84d38da472b65afc70d46a452f11a0a51b1bf4c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "647a08fac6a9c26c5075ed1828a9710f50122fcbe1927a21833341e4faec316f"
    sha256 cellar: :any_skip_relocation, ventura:       "33beb3a5381f13b1b20f4a1d812115d3c4b97c9f2b7a007115c38294fb7d3be3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e1587a7624420aa1abbde1c76472511e53672dd57e92f277a2b7c3857b93959"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", "completion")
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

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
