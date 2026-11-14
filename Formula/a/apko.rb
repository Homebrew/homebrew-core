class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "cf4c321c2ace9d29b0ef27c84b7cb45d590a9c16078826e553c1f38a5c292164"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5051731f59695fd6ab766fbcbc200d8ceb08f00a5ed879b1a4c565f7ea56eecb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f890d55ae8845c97e42d27c2ac1d2a7143d3ebef9bd0c42521c7c4612a01364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9bb4ded2a9c3d0544153e1e9779a45f8734a43fae60f88f0e7140a90530baabe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "214b1e0b66247d35ef8975e018cbc5b68e30f2fc8b5c80653a2a91d333cb2e0b"
    sha256 cellar: :any,                 x86_64_linux:      "f2472671ca8033491d2bbe6b9523956b5736d94729333b965bb0b6df10bb2619"
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
