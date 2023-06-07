class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "e095a6572a7b5449e1105566d874ed82af321fd35e684d6fd055445ce3f17ef0"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32cb2f6f46b6731a310f922512acb5d81cd4da8d63db4c7683fdd6a1c0bbe6d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32cb2f6f46b6731a310f922512acb5d81cd4da8d63db4c7683fdd6a1c0bbe6d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32cb2f6f46b6731a310f922512acb5d81cd4da8d63db4c7683fdd6a1c0bbe6d2"
    sha256 cellar: :any_skip_relocation, ventura:        "88682a1f07535f4788f235804063ec70a071ea56f0baee51a77acb65972fb2f3"
    sha256 cellar: :any_skip_relocation, monterey:       "88682a1f07535f4788f235804063ec70a071ea56f0baee51a77acb65972fb2f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "88682a1f07535f4788f235804063ec70a071ea56f0baee51a77acb65972fb2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab37aa3a03d97e56962f320dfdafcf07539e74dd3a656504d8fb3620cf4b0c3b"
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
