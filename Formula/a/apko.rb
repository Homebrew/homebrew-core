class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "bfd5187f39d4de73d2a53207d94bde96d69681644ba8ede1ec9f913958821db2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d583b872a59c957f7cf8b12ad57224253b6340dc35a0166e5828f6524fab061"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d583b872a59c957f7cf8b12ad57224253b6340dc35a0166e5828f6524fab061"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d583b872a59c957f7cf8b12ad57224253b6340dc35a0166e5828f6524fab061"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdfc15e2846f89d11c9417fc801e6efe8a677fa98bd9618b4d8807edf837e8ae"
    sha256 cellar: :any_skip_relocation, ventura:       "cdfc15e2846f89d11c9417fc801e6efe8a677fa98bd9618b4d8807edf837e8ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b1c59a52002667dc886cc03e956797ea8f787dcb26b62e357a13c340b5f9fc"
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
