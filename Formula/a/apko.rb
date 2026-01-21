class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "a283173f97bfbbed8f56828a67deca6753b7ae136447b3ae71b66a331182552b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "263ea6f85d753692db4fee2a0e5713890083ce66a40486cc2efece88c88783fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6388d9f4c2d72f3bef772d668c95db1f829f4b719b6a3d2c91e0e321a3a0336e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1462e1ade77406b5197b4081e8b35a1892c9002ae9afa5b8d62609c19ee696b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6279223a68d7c3ac0b32dc50a0f2192d89dbdf2047a6b3fcd8b3dea434bb586f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8ef92889ffbd09df7d5e7319dd852c291ea22dbf63cb912f69b47ac375f61c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773a8df544470536ca04b68273a800566ef5e9c62de7f7811157c4d931194a38"
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
