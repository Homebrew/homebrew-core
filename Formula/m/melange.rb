class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "79d4fa8efbfd73038191412605f7e0c5a42b0e9de4c7e61f24dcc1146a2de225"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e37768013ae87018a9ea2f4e5f2819d27a1d371a79104b81e5cd9a167fd6d590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd2a3d72d8ff04ecb1eb8b3b941de463e2819fd556c2c95d71d1713f42d28854"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b4a8ce5ef17f71a17745b2bb9105c3067aec03a1151a0c183657a8df63f4a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "84ad93e96e1c778c896c5eb3b01ec5fd1fefd88a55773802d294dc08b9aaf28c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88dde48dc8226dacaf7f97e734b759c9de31c1b51d1b42de968f5634f74a9637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99a2a49516099bff14a2871d65dc232ecb63c95ea1b830b08c227a826930e31"
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
