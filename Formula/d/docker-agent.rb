class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.151.0.tar.gz"
  sha256 "db6f5406ee84aa4e662e9d021e9a58d4511c76a6deeb553b75c5fd3bd6185790"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ea7dd2c4503fab976d66b3d49b1aa2a145a3fb4bf7a865d543ba94129b8418f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e57c386a4c2a5d2a340ef7513f1d139550b0f7801060ea4d2fd154590167d2a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "510cead935d5fbf08423e0d63883ccfebcf83162c5163af0ce9e5bd58faaa41c"
    sha256 cellar: :any,                 arm64_linux:       "b2c42a250d473d3e9222c6efcd2310ab8d923e909cd532fa984873b25c5167c2"
    sha256 cellar: :any,                 x86_64_linux:      "eefb93e6f9f5dfb587734c7d1faa2c62f7f85ed76e09c94be1349f27cc6d71b3"
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
