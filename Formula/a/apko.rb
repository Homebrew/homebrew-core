class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.15.tar.gz"
  sha256 "1353da965103d326c79b0e6dd5c9b6f359a831fc66357e9bf01cd9bb182fb7c2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c4e7432ff3510f7eaf476f5910179dc3b94eed3b32932e07b2543e9e09394b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "645b98d7543e9f7e3ed3301af4bf9aa6b33d3286564a515f92d2a8ac8a475bf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "947b12d48b70856ac7e6ca32794f63aabcca33b1d6e9b6f98d1a41c628a38b00"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "56f2d3ce382db8f1ab82c2f9ffe3b299d4c9bd9dbc0e9051fba989effc7474e2"
    sha256 cellar: :any,                 x86_64_linux:      "63112c6ce7dd992c0db2e70802da05d2ed46ade82a85f58248446c7044759ae7"
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
