class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.11.tar.gz"
  sha256 "2cfcf8c51eb0b14caf8cbb98cdb6da6d1031d87fa1db0b1312eabca9f28aa3e9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cecf0129725c53e0f9d362b4c4cb505d334c8b0b770720d324ada51cb0950c23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f319e869e4030439af5c1bbeabe7df47801b00d7e5bcbad18fccf2c0413975b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4406dd18622ec5dde544fe6264a93cfcbf1ec13e3885ef668184938d27a65845"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b52f579b1e6202c28c512a3ed9723b215b4e9e15099b76199cbca9cc306aec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c04c44bc84330957e37b9b5ba9cd04c2b9808cac7c3533c779cd745aea6fbd33"
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

    assert_match version.to_s, shell_output("#{bin}/apko version 2>&1")
  end
end
