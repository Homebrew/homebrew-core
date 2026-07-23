class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.2.28.tar.gz"
  sha256 "7272df59a2bd8b6573164ce2538d087bf8db22290b1c1ab5dd235f33f9eb0bf0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ea37d6e49f917ac0b12ae83af941cb5647d71d46d9cbca7f01813af35cb944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a6a64788c880cdde8ba7a795683d46ab09afd59c6e52300d29da0a9ec6cb84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d19cc738f287631152d7df5b0d8834f4013b39e62ea5e50a7dd5d51ab07f4b3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b5744e5746ca25c82bf1a1635bf6811c001ee424d97c886d4281fd21acbdd9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0f4645c83abeb4a1d2d08eaa952312592c1330ea4896e33ef775ac3f7e70b4c"
    sha256 cellar: :any,                 x86_64_linux:  "d2b333fe053361c30779f877f31c9ec23c9b06ca8d0303d53fb9815cbdec5abe"
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
