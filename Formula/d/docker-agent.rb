class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.138.1.tar.gz"
  sha256 "7c2873e2f41813b3b47fda014ba2950cca75bc0ffecf84f4a74e7308e601671a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9f64591b0fa8a9bcec77408c6f06b20032bf8d5dd065818043b925a49557f93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a74f2af011391a858659b6b1e705977cde0475d9a5bfda9657ff071a0fe57fc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b85dd3582a2e86bc39f89481ddbe86d4f9966e60dab4b44acc95e3a2853e2368"
    sha256 cellar: :any,                 arm64_linux:       "35ce41070d835550ffde64fa1a24c21a7f0835756392a51f6e7f7e13dd2f37c4"
    sha256 cellar: :any,                 x86_64_linux:      "5f58585d0bc1ced866a8661bf367dc530ade7dfe9bac8720235e703125ec0cf5"
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
