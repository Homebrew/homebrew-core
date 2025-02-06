class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "366d7d67f704eec7682bad684a507cb64c517029cc176b6f6cbb751ba4eebfdf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7303f4179c304d7fc15d3187d4ad8a361ca240c2102743424f6b8fb009a9a56f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7303f4179c304d7fc15d3187d4ad8a361ca240c2102743424f6b8fb009a9a56f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7303f4179c304d7fc15d3187d4ad8a361ca240c2102743424f6b8fb009a9a56f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bf1721ae313e59122d36b2463892155237883eca6ed7ebc89e5c5822e8669c4"
    sha256 cellar: :any_skip_relocation, ventura:       "3bf1721ae313e59122d36b2463892155237883eca6ed7ebc89e5c5822e8669c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faddfea43f2a960673461db492b9aac4f43525d532f244d241f7e9edca164ade"
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
    assert_predicate testpath/"apko-alpine.tar", :exist?

    assert_match version.to_s, shell_output(bin/"apko version 2>&1")
  end
end
