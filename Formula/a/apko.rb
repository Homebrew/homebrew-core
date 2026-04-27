class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "bffb57b4fdf5f304018a09563d6d743d3d7c05b6c831a53e62909373ef33524b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b8f5dc14e2b8d6dfac086f2c00e50b3016cfb83a46a6dd39b814095c40efff6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb780f8e47761147670c1a48a8df20a17349717dc476e2c1cfeecc2476c70a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91bbda286c65215891f3fd68864a7a410700954a5ea4726e2ed4130d8297ea70"
    sha256 cellar: :any_skip_relocation, sonoma:        "23753e07dfae2b30a0b914fc028ea3fbfd714f8b8122891bb114b1c4d0d06a3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f568fd546b52264a53acb369ff571130d40efda29f55fbc00181cb7fa8d9e0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81cea7f644fc2af3eef8d71be7547107f6e69f2854f9c029d3bff493938690cd"
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
