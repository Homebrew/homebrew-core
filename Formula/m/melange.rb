class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.50.5.tar.gz"
  sha256 "f9ece55f008552768b805073f043941c1aff17144d00abb668cd2a616c677292"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cc83911c120c1d37a4fc1d1c4e07100414cd9a866a6422f5ba7ca78beb25075"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4203978b634d3e6798d5112861b32101cfc8037ba56c91175ef906b160023b25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e163816fb8190968a115f8f41f5f3e4c8ce0b427b7a69efb48cc6236d4a9cda"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ad76d69e3ed8a37719b25a287290eab86dfe19d2c4f2730c8371ca1e4f10275"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02cb7b8433b7c5dc31b85418e5ec1645d3441fdec19864e7ada09f7d04224a35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e80739f1f0f2467fb8dfdaef32d25ca14374445dc7989881e8f9c8878af3101"
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
