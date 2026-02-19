class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.1.9.tar.gz"
  sha256 "b0954b2e51518a9d985901ffea95ee25086bd384fba84b24f35f4c040918628c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fee316298f6ea7f5d29d8c9c45a935fbc972e73be2f0d9dd032fcdeaca59d15a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e87227aaa8f756ff9d19fadc67053458dd51818ee5e41a124bad95de50cc45e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af929143882262764fbb06984fc4d33e1e76589c12824b12ca0760392b7b0f3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "382e99d7cc627925244eb13e5bdfe30dd99f1feed06d3b62e761dc63719c7f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b877c6c11082496c355da2a523b6aaaa3fbc2a44012cf8f2fc2308a79af362c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238a9c0c3ff927bc83033c7f9aa7fe0f5e3145b7f177ac3461bda798e9f56006"
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
