class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.19.tar.gz"
  sha256 "77a4e36f9d20fab5cf6447fbd6c00de7e2ab9a6bced781a8dd4ef862bd6b5cf3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6780cdafe385ca7fa013e334a557457288dd971f6a9381f072523f339aaff83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4b9d2a8961666966b2bc4838a3383749933645b66c6293b7e275d57d77dab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3103cee6254bb5d4d5cfb7c91468470bf5bb3d645768f15cd098d20cfd8e1ad9"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ff306f574aa37d89f4d92a1bc89563d26303dc51883131b12bf6d9cafc3a17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee0103054a594d249f7e81a69576bb3c66fe43b5300246927e78f46f7f7c0c52"
    sha256 cellar: :any,                 x86_64_linux:  "87afaf26af388754eeebec167eb978523290eee2aca497e16b77f44b5a55b1ae"
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
