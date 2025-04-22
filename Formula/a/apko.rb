class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "bf2dc892eec53270ba740d1e074286c94175686f0db16809af0c53c3762df084"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e9e6b4b9da874f0b177822fbdb0b853d0baf0d70ba95908d2dc46aa30da0c29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9e6b4b9da874f0b177822fbdb0b853d0baf0d70ba95908d2dc46aa30da0c29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e9e6b4b9da874f0b177822fbdb0b853d0baf0d70ba95908d2dc46aa30da0c29"
    sha256 cellar: :any_skip_relocation, sonoma:        "cff33b2f4ebcf8a30364b0d8fc226bba30bfa56e8d3a3a42c035caf8e33b7e31"
    sha256 cellar: :any_skip_relocation, ventura:       "cff33b2f4ebcf8a30364b0d8fc226bba30bfa56e8d3a3a42c035caf8e33b7e31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fe18ce5ee09850bd3b188e4c4ac4eeb4d65ead0bfdb5278d1e09020b7fb8e69"
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
