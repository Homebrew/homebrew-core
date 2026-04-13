class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "39238424c152767d94dc678dab48bae0674318d03964feaf1bbc83ba0301f43a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6dc6d0a390c8fd44e6b1dce27007cf1f99dc15b22298a889d898ffd6f03921b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "771365e69006c6ff43a99890caa719b003b0732c34d84e0e50edfd28b49ff20c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bd5689e3413325137f520aa1687b37984cb5897bb8b8d672171bcf078571575"
    sha256 cellar: :any_skip_relocation, sonoma:        "efa2946d2a263b365220a075fb39ed5f39eed6edca79d3295172d0ff6826c137"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82fdd26e53fa42cfeb0d27a8bc150d7794f90b04aedf50287fa906c0b32cf5d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7756dd9bb5ba4a38d43069c2dde9e42870f4a52a6bb069928770985ee3c783fa"
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
