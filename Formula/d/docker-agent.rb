class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.161.0.tar.gz"
  sha256 "c3e47a0c3425cc9edb13380431b8e1da744310e6b3f9270453e14595e6e21d47"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e4e797190b8f9eea96f058984d528b7fb2baa3e4e10fc41bf315de48cf7a19e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "892c419e30bf7bf80e7b53b731f79180ed8cfd99646828a35b972439854e1622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "760cf7c2fb89b680fcd733d7f1508d832d523ec89142e1df731cfa7f62c6fe88"
    sha256 cellar: :any,                 arm64_linux:       "456e686a012cd16eed9eae83b8230d2e2e60eee64bcd632a55244e28d82fff6c"
    sha256 cellar: :any,                 x86_64_linux:      "e46409572a59df72586641e86ea79766b1bb70179ea61423261b7551820debb2"
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
