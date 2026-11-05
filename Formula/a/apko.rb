class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.16.tar.gz"
  sha256 "7cc89e87e4bfde575f15ed623aa517e9441e86dce1edb50f296c90dc719cd39a"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72f3d99866fa7d48fc548eee65ea15cb7e410d109601c9c274ffcf3dc748b9db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "202b9c7121924bad69711f44b94601a44bfc5734e7c71ee3c97c94953f3f1696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "789c131046b32c89f7c368e08297d64225939c18c48d87a956ea44fb2ab4b1ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "427b0ce6171994f05e65432dd5484b98632302747f0cc39bfd795d30c50d74c0"
    sha256 cellar: :any,                 x86_64_linux:      "9d1a65bc05d21afcb6ca9dff4624cf2880503246eb073602c25be4ce45b6be6e"
  end

  depends_on "go" => :build

  # `test do` block queries Alpine package repositories
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"apko", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"test.yml").write <<~YAML
      contents:
        repositories:
          - https://dl-cdn.alpinelinux.org/alpine/edge/main
        packages:
          - apk-tools

      entrypoint:
        command: /bin/sh -l

      # optional environment configuration
      environment:
        PATH: /usr/sbin:/sbin:/usr/bin:/bin

      # only key found for arch riscv64 [edge],
      archs:
        - riscv64
    YAML
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_path_exists testpath/"apko-alpine.tar"

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end
