class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v0.30.27.tar.gz"
  sha256 "70cf3a4b47da836dd1d3dfc59460277075b7e251df14d79301992a9ea4df2995"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bea4fdc72135c96251fbbe71286db8f9bc204bae8d7c55e08bebd1afff47680"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d236b3f59b2e3863a18da94b7c56c7f0fcb2de746c6f4f50ea5d18a96c8c6b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21d3e3b7a490daba13d9351821480b86a07f287501cf89f650d878fdbb297c4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9016e5bf2cdc1db151ef689d2228db929f3daa1aecc24bd4bce666d997df75aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d8b6ee06315a9ad278b05f90d472ba9ce069d906bd61fb07f026853e6a897a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4075f797f72aa9d1d3143ab29a8d16648e57cd9f16fd4a4d631e2de09b7d82b3"
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

    assert_match version.to_s, shell_output("#{bin}/apko version")
  end
end
