class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.157.2.tar.gz"
  sha256 "a292ad0e90718b21710d881cc50441dbbd8047096536cfca5b660c1fbfa78583"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5006f6c82b2363661593666765e5b355b7bf8619b245cc28407fa32f9e5264b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a0f996c154d689accd2dfa9eaa27c63ae1d3fdde3d3e7c4ee126d4de3a1a9c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ec1978d4a974aa5b32a48e3e90b06e9844eaf54a37ca2a6a05cb78e616257b9"
    sha256 cellar: :any,                 arm64_linux:       "8171c2f59d3be53c1e2a313a92099d831affdf82b5aa68eb3c7197633280bd19"
    sha256 cellar: :any,                 x86_64_linux:      "76b30be4c1cbc2f96b43068eae66f14a8dfdc4922290b79850daaa3de63753da"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/docker/docker-agent/pkg/version.Version=v#{version}
      -X github.com/docker/docker-agent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"docker-agent", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("docker-agent version v#{version}", shell_output("#{bin}/docker-agent version"))
    output = shell_output("#{bin}/docker-agent run --exec --dry-run agent.yaml hello 2>&1", 1)
    assert_match(/must be set.*OPENAI_API_KEY/m, output)
  end
end
