class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "9dfe9bdc3c589db30c674b90b7d92b09eca8e245f41319c8fedc831a06b646c7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4206e988ddbbe28b081ccc2d0d63642d7cdcb89ed969281de3a43b1b54b88219"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "351ccc583a8e78e8547a1080060fd5c55537e93ba8f5eee513f39f96e933e1b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92d42b5bd5118e68805da22be1df63d2cc6ec3b34a0cdca2fbc4bc416305de45"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f37c9f4a1790ef31c44070bee53572e1ca427a433dbf613d991490f0c3add285"
    sha256 cellar: :any,                 x86_64_linux:      "22d6cc64679e0084572ef3b538e8903ba8b1e04ea006b2836ee469a96cc79e02"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
