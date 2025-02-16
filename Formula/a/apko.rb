class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "fc71b979d5b593e8d1be4037e4002d12a2f1b7ecd7a86020d1b93f5e089fb17e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35653dee028b4aa2f12e81f7d015eb208ce62a97901f3bf77da3f9da84456d2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35653dee028b4aa2f12e81f7d015eb208ce62a97901f3bf77da3f9da84456d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35653dee028b4aa2f12e81f7d015eb208ce62a97901f3bf77da3f9da84456d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "58378910f0f6e12a3b9180168ac9767e494ead2fbb75ed73a0f14f78a6986c44"
    sha256 cellar: :any_skip_relocation, ventura:       "58378910f0f6e12a3b9180168ac9767e494ead2fbb75ed73a0f14f78a6986c44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c28f5335085dddcb79de2e132c843c9411a36dfc8331ec266dce923e5c173fa3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
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
          - alpine-base

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

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
