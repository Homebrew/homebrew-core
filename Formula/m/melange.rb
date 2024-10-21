class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.13.6.tar.gz"
  sha256 "baa2500c0c7a19a5868a317699ed8134644d89b6c37b7b4e38be29945b8c05a1"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f01dcba45a80fc35cbd903ee6e8ff0cc91a6ef1744f914354f528fb296061305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f01dcba45a80fc35cbd903ee6e8ff0cc91a6ef1744f914354f528fb296061305"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f01dcba45a80fc35cbd903ee6e8ff0cc91a6ef1744f914354f528fb296061305"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bfa78daa94301fa9a11fd857f1c3573ff619ec1581988d450ff0630d02c6a68"
    sha256 cellar: :any_skip_relocation, ventura:       "4bfa78daa94301fa9a11fd857f1c3573ff619ec1581988d450ff0630d02c6a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f9d133cb99f6f90f44e796337b936805343385dc2e3defa89ddde1255b4009c"
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
