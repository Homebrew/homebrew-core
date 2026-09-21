class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.142.0.tar.gz"
  sha256 "cb39414b79e96fd9113ce2ac8c28941ba5fe69cf6cda9166a3b47b5338608aa2"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad54205293f2d58ecf52eade1e00ceea4af34877105ffaa594d3548529e085d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8d4f3d3e414d08a95a361b068834d4b7e80a95f480697812be7c3e704bd6609"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0ffc560d54b440fdaf0a3db60e609ab110d1c6d28bbb70596bb676aa51d7414"
    sha256 cellar: :any,                 arm64_linux:       "40fbfb295c15610187acac3c915db141fd9af715116327d73a6eadb6a9ed2abc"
    sha256 cellar: :any,                 x86_64_linux:      "88d57e88bbc93237abcfdf5f6a865b068aaf2a81b825dd9a3dcfddbd86b1f175"
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
