class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "0a409148a9f7e0bdf2bab090fa256ea8d48c92302c08e8d958c4021ae5aef84b"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "927e80bd176292534bb79e98f05cc387e8a0c0d15cea573f5c51d7ffb5acb73e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27f6cf41fa3f3b2bdaef8f5972c6854e2e870694d7e23434736da7a315b9d901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98669ba72175ed797160215b5feb83f49cd8f3c12823b0b742f201589cc3f4b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dff5364604efdbe0d50811749999cfeb6c3587c080dd14a69cd1e4cea7ebf3bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4998dc9d05c0a1294bc46c86df42623c54f14ced1af5e215b2bf68ff2909d1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "432e3c8d491621f40185b3aeaed56487e395a3f1b47e302b298ffeab7cb85a56"
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
