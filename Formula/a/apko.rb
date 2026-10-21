class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.12.tar.gz"
  sha256 "16118b9eb7e52519219b21f414418be7bcf3739beeb0503719f5df9ad8a571a2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b2b7e8bef6a736a19389a8ffc071ef2bea6799c008bbe9085b57fd889b25462"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "30640fc06cf3a80fd0f297cf2566473ce12e328737eb867e76a5ccc4470d7bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "02e2cf5f44f229f37f7262facd71f3183a57f4e62ac2afe640c2673a3a27a317"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4250709e808da2865bbe66f1ba3a6b8e84b45f09cbd94d8f95d1b32c93bdd528"
    sha256 cellar: :any,                 x86_64_linux:      "6c42f9d29feeabdf8774690846b345040140072b33b561527a1200a1cb22b1b6"
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
