class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.9.tar.gz"
  sha256 "cf1ccb188ad327300b564159908644a0e59329922e455643bd45515274ee4765"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806d462e4ae73c2a9c8f0513034d071eb1a40d8c2afe82ce6a93f7ce4dc78002"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb3f7b69441c02e6f70797a7d9bcf8ea321913995fd99af5ffaf3bac44385159"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "155ca2837bcc8763e2611d8b408c9579e27550d5ca3864109a94f349d6c9e554"
    sha256 cellar: :any_skip_relocation, sonoma:        "17b988c444499273af7e2ced37aae8a47f1b6b17cbbc04ab3fd3ac8eafb200df"
    sha256 cellar: :any_skip_relocation, ventura:       "8396fac58ee82445767e2bd3f07a7fb5b46751825ab1b720ba0907f0cc5a4167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f26842d5831427a4c51f26b32842b543e8afbbbbc47abe202bd54fad66b285"
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
