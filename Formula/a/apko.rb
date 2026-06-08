class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.16.tar.gz"
  sha256 "505b87e7e4a4d17d75f4d8fb23df63a4dcb03df2f7243073a5266ca45c037c5f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a559ce45bd44f1b8cf8f69dbe06e70ce34136cd53e64cd9337687c79ff8037c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c07092d93d6047345b62b781d6000c98a89448123b2fc89783aace5de1a7547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d672179bb4e3938a92e3b46a8633effef788f8c5259159d902966ef9c5ecbdf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd674d41bee8c15f128e3153227c2eaa871660e14e99b73f6bb36ee77986876a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f4ca62f03b0933ce612fd5e01e4861959e8d26dd42dd5900f57b8be60fbb7a"
    sha256 cellar: :any,                 x86_64_linux:  "11eba2151ec3f03b705d0780edcda20efcc6402c4882727008bc7d200cdd287a"
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
