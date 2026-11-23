class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "882ac1b9971a5e03b6f417c296de7e1cc9297b3e207fb72fb954eac928eb7b24"
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
    manifest_sha256 "df985b6d8ba3d81683c4bf6ea3598828119879e84a6d2a95650e45cc7d76d307"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "524b35f7a4341e693550b69c191438ecade71ac87b502fe5afff56353503bd18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47c75d57e72e7a1467f9f244357e7be45d9762568868d01bec17247cb1f2ea9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ec481cc890db44a68429fb8fabd9f0c7977a1d8cf48a81e28d393388d2450ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae84c63aebf2dc7b2755c3c03e1ee2e17f5ce552ebf80cffcdca697b1a5c5a27"
    sha256 cellar: :any,                 x86_64_linux:      "ddf791b198be173b295337ac6662935a3aa12e99de377c63341037fce3657b3e"
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
