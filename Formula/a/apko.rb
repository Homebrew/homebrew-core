class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "0377bb2968bedae14b91c7f50a06b444600ac2e7d11fdf49d483950be0866873"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af9070b054b209a2481979ba7621bcb37b625548e9505b950a97dcb728493231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af9070b054b209a2481979ba7621bcb37b625548e9505b950a97dcb728493231"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af9070b054b209a2481979ba7621bcb37b625548e9505b950a97dcb728493231"
    sha256 cellar: :any_skip_relocation, sonoma:        "01f9f42f241f9606dde87407811ed5eb82e7f780bb18eee814208d335bce7c43"
    sha256 cellar: :any_skip_relocation, ventura:       "01f9f42f241f9606dde87407811ed5eb82e7f780bb18eee814208d335bce7c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b14842b4b026baa4867b5b9cdbf0029d56083751dc88a0a2451e126acd0c6fb"
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
