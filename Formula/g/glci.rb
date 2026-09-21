class Glci < Formula
  desc "Run GitLab CI/CD pipelines locally"
  homepage "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci"
  url "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci/-/archive/v0.8.0/glci-v0.8.0.tar.gz"
  sha256 "d5da2c86d3e17d1080f8cc577ae84b15ad9ef08a2fbc63dd9c72fb3f55b64f96"
  license "MIT"
  head "https://gitlab.com/gitlab-org/ci-cd/runner-tools/glci.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0e8824267bff105657afbac27476dc28be5bd718263a5a79f14002402967a0b2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0e8824267bff105657afbac27476dc28be5bd718263a5a79f14002402967a0b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e8824267bff105657afbac27476dc28be5bd718263a5a79f14002402967a0b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe8a8bf2f414e0e820a4c05f9aabdc886df3f54ef3882b7d3ad98fbbf51d1e0d"
    sha256 cellar: :any,                 x86_64_linux:      "63d60e7b49598b48d2ddc4856e345b2045257aac041c5b57682bb66cc292ccf2"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = %W[
      -X gitlab.com/gitlab-org/ci-cd/runner-tools/glci/pkg/version.Commit=#{tap&.user || "homebrew"}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/glci"
    generate_completions_from_executable(bin/"glci", "completion")
  end

  def caveats
    <<~EOS
      glci requires a running container engine (Docker or Podman) to execute jobs.
    EOS
  end

  test do
    (testpath/".gitlab-ci.yml").write <<~YAML
      test-job:
        stage: test
        script:
          - echo hello
    YAML
    assert_match "test-job", shell_output("#{bin}/glci jobs")
    assert_match "test-job", shell_output("#{bin}/glci show --plain")
    assert_match tap&.user || "homebrew", shell_output("#{bin}/glci version 2>&1")
  end
end
