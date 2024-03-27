class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "457924557573736d4acb12fe35d26ec6078494828e22a01833fe2fee48962439"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30dfbf99919b03aae24aaa956896d4746940d4903f609ab47119483ba4d14ea4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a20a3ec692be167cd85b359301640d306da372bffac6bac4f04b4030c0318a60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "087f226bef51b2d903dd039cc6210474fe858b2ff091d7537e5139fc19caaa68"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3493c41773935c294ad33563628e0003e5f6af650f4fb6d79e182c6195cc5b6"
    sha256 cellar: :any_skip_relocation, ventura:        "fdb4eab30f45e72042921b88f1d807fe645309a33d232b465346665b7bea405e"
    sha256 cellar: :any_skip_relocation, monterey:       "6b5d315a084ba1822c22b43622e2a6175c957ab42e1153df9b33c59eba29039a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0b6482dc3bd02c9196f373ba662bcc966387cbbaa11cff985cd3af7e0d07042"
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
