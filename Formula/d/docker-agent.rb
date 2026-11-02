class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.156.1.tar.gz"
  sha256 "82fda1c3fdfd5afb830d44f5f260829402a9d1f8153ee0c5c384481858be2e62"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26321249133caac9f6e42ffabd06b6cc1f32ff572828f30477ce5c5853c166e7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f2b8d686b54c1e976bb88f5eb61e0c368a40eb8349e2f89481836b99bb0a263"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a8e83e3d41b3a2a493252f368df619212f9fe103b74293922e9e5e0614e06fa"
    sha256 cellar: :any,                 arm64_linux:       "2d4ff7f4b82f1745b05a964a5c41d4f50b2f76f0d1487e7c57468a90012d6e91"
    sha256 cellar: :any,                 x86_64_linux:      "fd9d625b21e150db74473f8582ca629da03e925d55495a0b6d2111c334f4c6e9"
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
