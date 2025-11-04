class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.20.tar.gz"
  sha256 "6ec12bee3cffeac9eba21d00d99cc1a66ed033a0b69cdbec4badab4e3f545f9e"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c21d9e725506285ec6793ea463ae3d914002c52b0fdd33e980e273fb0412228b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c92ad1b0d64b832fc554d17752541e9267fa943ec35542c710aae4fe481bc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3e2c451c36036d88254e6251470078a8ddb2b2067a5a197e8fc68903d51e1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e3d5f77a60c3dcc32eeb67a0d63628c46b8977cfaa3c771aede28a754284ae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d53490460dd5a7dc699dae2ee4095fa694722b9a9c81b741584e2d579737e145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93bbe0244c0a4218f135d53351b266fb9304274e20a40081178cd4c854e14d32"
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

    assert_match version.to_s, shell_output("#{bin}/apko version 2>&1")
  end
end
