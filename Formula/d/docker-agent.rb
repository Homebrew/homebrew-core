class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.161.0.tar.gz"
  sha256 "c3e47a0c3425cc9edb13380431b8e1da744310e6b3f9270453e14595e6e21d47"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b42572859cf1df8b468df91e08a9eb794d98332074e09faf3a0058813dd91333"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "761f3b627ac4002b649465e029983c3346989726a7a56a61cc932e3d3fb0e3a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e042b6404e2258e653f441a043bf446db7a959d6728777ced4bc575d701e1790"
    sha256 cellar: :any,                 arm64_linux:       "1a40873bd3462c79f87f8771eb033187b6df6079116d81906766891608d203ba"
    sha256 cellar: :any,                 x86_64_linux:      "4eb2a245008c20aa02e1543dd71cdafa1199d43c2c709de2aca2de70ba0d833e"
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
