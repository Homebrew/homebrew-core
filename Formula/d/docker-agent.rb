class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.127.0.tar.gz"
  sha256 "d2ea20d6ab54c7e308602620b3e9b7c22a408170f0c6e55a134cee928c4965fc"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "152960b4dbc93188387cc4f92c0b655be703ee0419041442836bf9f8d5f7c7f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa1aacb76e7479d239f3cc2026981d2614926fc1542ff7187bfcf243e95e3877"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2e332e153004432303a0c337b487ee6857c8d3b5ed7f1b160ee61c2f74b0302"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e7f79392108152fa0ead3e7ba4f0cc97f8f55fdf50911e87c913a7f19f422fe"
    sha256 cellar: :any,                 arm64_linux:   "3ea8257733169020c8d5a7ceb8b3b6a48f0e1be573c597ed99eebebb7f8bf2d3"
    sha256 cellar: :any,                 x86_64_linux:  "115773eabea846bdef1b2bb05ffaefdc4e3046081440c7233a88b7254d5fc571"
  end

  depends_on "go" => :build

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
