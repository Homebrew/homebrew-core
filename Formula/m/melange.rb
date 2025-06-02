class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "58184192d6563f6048257d58e996b6b4890e11f9dd9376f3c304970d8952d671"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cce3e787a3d914fb24e9d77497d35d3b94aa2c90b2689447353041bdc22c1c47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "645bab9634c95a8f5a2f3b874b40a31c9179cb33310dec78a4f9b4159a842b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44426ee3d2fff183b6b33275d05567805b76b8718640394c0348795c0d7ae7e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e55fd3706d1ad27820f73afd17d00babd686c598fcbf00b9262836aec69b144"
    sha256 cellar: :any_skip_relocation, ventura:       "93449df0e575d6a6775caab5a1fee72e4446befa6c7fa0d85cb6e1ff000f40ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15c01a6d5dc84c10a30b274bf4bd8075591420ede01b41b62a785cc2dc525060"
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
