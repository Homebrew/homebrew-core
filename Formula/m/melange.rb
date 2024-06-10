class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "14308e2c38b2a455e5314d2a1587e165767e7f9b58914de615ee2256bcffee06"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2eb991b056f1995e931f06e9b072822f391b87037b230ba73cb23d7ebda9178"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "275e31181ceab9e0108f7303cad52ae008447cad6ca97232ba78028255a1ae55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8f5e63d478798db1e1e27e87cd21a37d79ac6881e1966d36cfc4d28c96885fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d1116c91b43ba87f74126e475db52079c1bf6a75d40004b43719fa698b103cf"
    sha256 cellar: :any_skip_relocation, ventura:        "8571f62920a4a76954c7a55c47852842d1646137a9304990b8f075f06b6ca45a"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef32ca5bc35912d12406639a5a86f74bdb4b1f37871e48a602c018c6bce9e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c225f4f9f9d9d061442220437192406ec723ea221721ae62d8f35506bf329d8c"
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
    (testpath/"test.yml").write <<~EOS
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
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
