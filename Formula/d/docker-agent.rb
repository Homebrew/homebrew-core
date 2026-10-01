class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.145.0.tar.gz"
  sha256 "fb0dfdb8a654e4c5e20a230a7a725dcd3544c18848dcba712ea4913710e8ebc7"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"
  # testing

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "227b4c1b2bc9993a5f011c9260170777ed7f834f8b6e4bbc43f1e26ddec1efa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "099ed3766047c6528ce56d435c185483706b11049e7f91a5dc5e42a5d5df7761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fe2013fd2219944e5af2dc21e8d2844f77fb609861262a3b2b59002655d43d83"
    sha256 cellar: :any,                 arm64_linux:       "40e59dfc077ab5d9129517cb33353833530eae7cbb06ed9cb1c589acce4dd423"
    sha256 cellar: :any,                 x86_64_linux:      "3d3f8d033b33344c2e8b48ecd0352f39add3cca733222436dcae5cffe26b541a"
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
