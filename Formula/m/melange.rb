class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "7626d1638ca11144f946b19337b90b69b864355190a763f52bad1e11003db15f"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d5af6cdfcb10251ef514c5c82905c88e1814a128d8f09c9bced6f51f23c4d1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d5af6cdfcb10251ef514c5c82905c88e1814a128d8f09c9bced6f51f23c4d1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d5af6cdfcb10251ef514c5c82905c88e1814a128d8f09c9bced6f51f23c4d1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a4b8b324dc394a10d925f13dbe3bc3203fd28249fe8a8dcddb22ad43bc39728"
    sha256 cellar: :any_skip_relocation, ventura:       "9a4b8b324dc394a10d925f13dbe3bc3203fd28249fe8a8dcddb22ad43bc39728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24ed6ca8e20242085105bfd57a2fca0cc4107240975b170175bcb3e242f62b24"
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
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
