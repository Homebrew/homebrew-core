class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e990b5bbaf5099de226cb8ea77717982f74d0554a286595db0344d4c31173623"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/apko.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87608f7a1d4f6d87fe3e1664ceeaf632efacb5ab457fe5b1bc2e2853d8404256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87608f7a1d4f6d87fe3e1664ceeaf632efacb5ab457fe5b1bc2e2853d8404256"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87608f7a1d4f6d87fe3e1664ceeaf632efacb5ab457fe5b1bc2e2853d8404256"
    sha256 cellar: :any_skip_relocation, ventura:        "fe6631907ac94f47451510f0d52dda2b85e80c14fc4da53b8bf3c4a7ae06785e"
    sha256 cellar: :any_skip_relocation, monterey:       "fe6631907ac94f47451510f0d52dda2b85e80c14fc4da53b8bf3c4a7ae06785e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe6631907ac94f47451510f0d52dda2b85e80c14fc4da53b8bf3c4a7ae06785e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3cf277ed5c42073ee4b1f15f67f1452671bfe5b53652ff9165e06dac0b26410"
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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"apko", "completion")
  end

  test do
    (testpath/"test.yml").write <<~EOS
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
    EOS
    system bin/"apko", "build", testpath/"test.yml", "apko-alpine:test", "apko-alpine.tar"
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
