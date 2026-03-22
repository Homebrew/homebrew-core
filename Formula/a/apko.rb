class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.15.tar.gz"
  sha256 "992b91588fabc3f88a86461a55e02ea46ed2d10278c889c765163505f2567082"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e5d02c0b98ea9875a9e8829e18120feb718fb702e9bfcf39ae8b0b4a376036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3af7c84fc4e782171a9a8c4cf8c319a8ffb258596b46504b8ca0c4aaad5c31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd847e7ad72aa2977ed36725f1d038ec301e39f158fcfae19773faf5c9b03745"
    sha256 cellar: :any_skip_relocation, sonoma:        "56aab6817fd5300d0c400062247b2960e15b10c35d3400a15cabfc5707fccc56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3236b14bdcff8246f846bf0df0d0fcfbcf5c42d8d781baf710b351df29e988e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6caa94cacb5fd5f84748c3d5d54b11ae2cf209a1fa164801cf2881526e4861"
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
