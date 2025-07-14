class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "d0693e08fbd2e466c77b987e6caf110d6db5289439333ef13fffc13f405f7964"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fce7bf4a7320017daec46f1b6ab8c79deecf634dc6778aec56ca4bb434515a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3435cdda0ec38fad9a7b768d2899a237ed24fd75f414ef9bb85211b60ab816"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aee6e79b309ad02f28f32572455b6bdac4019b51482a8e7447df0c6a3fb105c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "992506e86ec387f1d5b2332778b38f1cae82848708742415431c1529e8f74683"
    sha256 cellar: :any_skip_relocation, ventura:       "6f784e7ebfa8a369189cbce4406de0cb2dbf108bff2965b3fc12912b712e95fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3b9b9ac6eb8eb59356237224d3a968961665797c4594aa7ad643bcb92609b0e"
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
