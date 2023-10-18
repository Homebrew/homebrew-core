class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "46e104c475e307df3b7f3c98a9a59bfda7837c7e3c029d43d4d6a3b1d0f30608"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd762f3b553f28979c97e1d54ed9039dd5788e80444aaf257f911268c875dc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f43175f4558d7c2319ed0905d591b3c56104581ba1ff4ef8e2bc1a0684742d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71f558f526421503c9a1d4e75c8ee1ebc968be48de1967300dd24614bd8560aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "30a2ce2e408ea89596e27c604fdbae3cc921d0612fce121c56a25d0b8e81eda4"
    sha256 cellar: :any_skip_relocation, ventura:        "a881b23d0d4d88b71183617680ae653cf909a487c81edd6b9aec00e8851aa928"
    sha256 cellar: :any_skip_relocation, monterey:       "fa3909f21f0f02bd655947d8964313a2449067af4d4bcafb2a62a860f53e8e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f0923a8539a33b491657dc47a3d804d5fceb2bc0d33811cae0d6c6c554eddb"
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
