class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "3e73eb3b5feaf5e4e64db368e4d971a8687e1a8aac43bf5bccc2081e4bd623bd"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55f6c04f91b679d01d3a77a26548c100b9e72f1132e45a406e49656a30577278"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10c272cd78e85be59bc32c21e0105131fa6b48db0e09a97efd32c86acd050ec8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e67fbe35fa72de6bc2307541912a8e7ba0cf7c567123524c672732bcc71759cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "c35eb2a18526a71f31cbf4635f8fe3c6b6156e00b880f3c661eeb6467b78c54b"
    sha256 cellar: :any_skip_relocation, ventura:        "581184176cd6db7681f37b316940e51548fade576f74b9943d32520c5c5beeb3"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e17f415b92f443b2a97fd92973882f0a36aebe534445a821a636316a3f6cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf9276891242cef12bab04134d6725583922fb15d26ef291f1d88c107a80fbe8"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

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
