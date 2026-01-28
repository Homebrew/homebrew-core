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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8c265cae2c5d7ad6812066917e97f28f32c517d45aeedc7ed3f14a2111a80a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50b819009e4e7c3e27a4a99c4525d11a2fda8d2e6a6c6ba33123e3445d4e4ce2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7a2231d7faecfa9d5308a18b087580ea75fd3a8a134b14ac9f43b03bbda766f"
    sha256 cellar: :any_skip_relocation, sonoma:        "15f3e448311a6474ce10593ad95b2763cd434d061e3648ee17ef3932fa2235ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82feba5b8415d8269a0475f39aea85e62d5ff81d85c55be8a54cf564f9968e23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c4fbefa021675d732a6fdf736b3cc201d7254193795adf5010848fad7b03e5"
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
