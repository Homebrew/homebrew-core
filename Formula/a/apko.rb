class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "b202db3f068d8c533fb4845f829febe7d60cb89693521bc901eb818ee348e410"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe5d121fb8b4ba9581c8b1e519f6bc2eb7cb77d4ae9288051d9ab2f3eb26690d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3b753f370e11169960da0521238b4ffabce8e9785a213ef6c496c7efdc7a099"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2eab96a52919e5b6668953007d58006ffb6d631569596980b82f765e491f7a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81a3433bece0f3c9fac89064280a3db0e38465cf933737cfb520703103441361"
    sha256 cellar: :any,                 x86_64_linux:      "abcf515e81259e449baf0f05932471273ba7a98801e6bd3475418e2290be3e6d"
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
