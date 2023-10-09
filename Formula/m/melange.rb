class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "5d2922e7f5b0af06df9d2e4386c4fcffe6e50c82879706826cf8cca8e90d8468"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0da3d9d1919f46181619250f580aa62664891364108aa7882bf745447a6c414"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f508dd2847c3576b513023e9fc8cd718a08c0908eb19bc062721c1551807298f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "019223bb33e8bcdaa313caf28e7485e2367bb5528502f4cb8b560e68add10d65"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a4e7e5f4ed144117f3462c5c74d415ca079ebff4712735e8fb24bae70a18057"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e971d93ba019011693fed80670510840e26c6118f5d064d03645c76834ad49"
    sha256 cellar: :any_skip_relocation, monterey:       "9bc356e8f4d14907cbd9eaa7f9f87713da42eba23edaeb5ea0f8fde644f75cd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f050edfa4334d9e1b13c043cedb47a620842d7476d04cf6f055ed3a184915da"
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
