class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.139.0.tar.gz"
  sha256 "706abfc596f69d5baa1ec50f2e14055567a8cf5109180c35b24028efb84f8543"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96964f7dc39207dd1cd01d0d48a8215480f32deda02d7c4d7aee2b53f5842a26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "080fc433c25ed10a18cf29f21ff63060cd3300a62ca4c715bd784150c0323e58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce78c0bae286a5f3ebcd45b0aaf9c965ccedfc932bb03c809b7fce553f7f5b7b"
    sha256 cellar: :any,                 arm64_linux:       "917b08f3b52d00da0fd3d0320191796864305a0b93bb0b4bb8ad9b37223bf5bc"
    sha256 cellar: :any,                 x86_64_linux:      "a63fa5e6e5daeaa4ecd5dac013d870310e9ee8e05289e722527c56055429d8c6"
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
