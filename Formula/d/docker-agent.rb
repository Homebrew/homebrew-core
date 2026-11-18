class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.162.0.tar.gz"
  sha256 "7cd9c017d833b7dedd055b8bff94077565d7fb999c0b02e5d6444d7d2132558a"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b37234c9f88d5c82fe3de359fc05a3e042a80968996f8d5e6e171659b6663cb3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29a5406f1fcea72e1fd3b3866727966101a8029ee5b5ef9b84b78a860029af77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f955199e69a16f378645030594758f1d6b53e407474bd862b8d081212d34ae05"
    sha256 cellar: :any,                 arm64_linux:       "c195f75d8f118db9b734d09dd0c31021a5ac2e82a18f8c74526ba35b8e3a6123"
    sha256 cellar: :any,                 x86_64_linux:      "4789b4c4b40a4d269396df722742fa1f45a975e2c8f9a5b7581d472364d7dd47"
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
