class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "46f4bc9936d838098ecaebb30cde2f046ef0230b363004c9663c4211c100e68a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c0d4a340f5e69ad64f9153cd03f1d1b7642d0fed9245b481c3bc59791c964fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfd747cca7e210bb280e623a14b13dafa8cd7e59c212d472fb4bec176ec1a7d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a460338a25634386ec43c0bb8c9286a77f24b7588f20fbe99b8c4f20a8d0443"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d678b5e52fe1c6121209abbbeb6a1c8edf37f4252b81cca0e6b18a8b6dab74b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122abb7087d0e0fb6f94a5df2b24c6d62c76b983dccde98a6e40060e14f654c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8aa3f0556a9dbfcf0c014c4c3d78b38ebeee70a7c13468274604027ca342209"
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
