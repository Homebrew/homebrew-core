class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.25.tar.gz"
  sha256 "923c47a5fa09a0d500ef1e56d6a2bfe5f0d663e687d05f9c0fa39d3790701894"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db1186a61880c4cd13865ed17681705cecb046a6324fa6410e1bbd8d04e74e50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f90e297cffd962d3eb3dbb1cdf034cb905dd54c70414260c31adc933561fe139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9cad6fcf7c70845b378b5154c3dadaaf8a35e8b9b913f888a95faac8a8116ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "942d2577461a5896b63e2f653093bd73dc5a470d690c137ead0219fbeb728af2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3fd8153334b22084299b51cedc1d870eca12dca7e5abc36a708ff48b6a0b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1dfc3228f21bf68a45c4b72db3a24b302902c98fa73cc790dfeee70a7e1ee97"
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

    generate_completions_from_executable(bin/"apko", "completion")
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
