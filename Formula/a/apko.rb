class Apko < Formula
  desc "Build OCI images from APK packages directly without Dockerfile"
  homepage "https://github.com/chainguard-dev/apko"
  url "https://github.com/chainguard-dev/apko/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "80f12bdffd008455e5cb25937cd21f0363bc180361e0168633374e1a86479c62"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbec612b9cf66dc76bb5e984f1d8e1526f2fbfd37f73ff95e26563169bcc4122"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f750938077dbda5e4c9e973cc605b5b1537d789bfe8f6757031535fb19ee7df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5999592f5fee8e8eb51d4f87c8bfe68574b0f29efd548cd213f50385c8bc36b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a0f548fd974edcfa2b2e3164752309a6e20fbf7f3ee456f29d6826c5a2580c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6346209bb232e5a464fed74b6bbf1b3423395f9b772f168cc8332b48b4cd8040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94736adc0ccc1e3d3d2d0f76ba183d3c6a8c9d0a5546080863adde645dcb55b9"
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
