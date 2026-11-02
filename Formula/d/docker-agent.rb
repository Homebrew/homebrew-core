class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.155.0.tar.gz"
  sha256 "51c75e10fb4f6b531671c5610a4437fb81fb609fe41f19cc4c7e2348daa9f1b2"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f06cde21daeca220d319c631f4efe24ce85a8da14ea93cd80c090989d62f5a70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ba511270a72c32943d3916a26a21dd7e5b38c1d32592894542e5f45b8939192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2294c718df22ba37fca04b8f8eb50777f69f2f49de0a22a1302cecb88143430b"
    sha256 cellar: :any,                 arm64_linux:       "951ae466e345412867d01ada9fc3326879aadb473774d9ffe88b509f72cb781a"
    sha256 cellar: :any,                 x86_64_linux:      "95e2fb89ebc048ae6e4d82dbe44faf3d26abe1ed294e88faf06ca936dc3fdebc"
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
