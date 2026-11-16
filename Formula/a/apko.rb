class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "6b493d2697fe0820950bb2701783b83e1c807b8967ea0ff32a081b281573cdf9"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02f0b19a9286bf3d0e7bcda6ea2789fba6420496a14190cf1935a01774037808"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "55be9458c11f1dd86547a4652613bc0624be29efb5c8e9da7604f37cd05dd1e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "213dd4091c922af584589547e72c2639ec5af4d517fb1831b21004718af3885b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb7b1a39e4e6ad1bd186c0a84d4ac9bb745a914dc8f8f48c2a913a6c01f2c4a4"
    sha256 cellar: :any,                 x86_64_linux:      "d8e85beaa155b2d62f0b66dca16376cf692a0f67de98ae81f2d27d7ba215e627"
  end

  depends_on "go" => :build

  # `test do` block queries Alpine package repositories
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
