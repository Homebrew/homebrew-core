class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "1d6416dfcc06caeaad38847322974a5c0593bdf4eb698818ced7269a1ae8effe"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f42ccb80ffe4b826d0696946680056d7e2a8a45100065f840c943f3ddbc5cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "616183dd2b5dacea35f385ef711e24b9e2551976d2486ce3c680575ab0e565e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26370511dfff7753128727f66acd97381c6f5ab5df794cef7bee1c8ae277d2d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc6a817552e6787640aa0679ebf53f5f161a6e631016d1c6c8389e13615a3cff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e661fe6c9e2fead1b05a47062c7e6e2b57a6f05a7cb876bab8a4cdad69546222"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27f9890b97b80e8ed35d812f3dcd828c24245527dde4900e3591ac2581da98ab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", shell_parameter_format: :cobra)
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

    assert_match version.to_s, shell_output("#{bin}/melange version 2>&1")
  end
end
