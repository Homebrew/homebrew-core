class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.23.8.tar.gz"
  sha256 "e5828bed6581c1417e26969c97d110aa94aface1fb81a8e26dd49da847633013"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "897887754ce250c488b0e04168020b2a17cdef0f07edaeb5b27d685051d59997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a49a0375a45988be94b2827c769118d38f4ef853137f620630230640ae247d20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36f5a0307b74920a9ebd5ee7aa38857a1644beb72f306ee4dbe848e8e95a9394"
    sha256 cellar: :any_skip_relocation, sonoma:        "61440d5701899091354459310ad696f486199cb92943ce225680c8a49e553772"
    sha256 cellar: :any_skip_relocation, ventura:       "04c62d43a3125f3bbc597a7e08e9be5b01206624cfd4570e4deddc0d5c04d1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30de60d125b3be68c18a5b86a8c803a425e9357b4efe21c5418e54405c3eb5ea"
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
