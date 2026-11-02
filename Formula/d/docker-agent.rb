class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.155.0.tar.gz"
  sha256 "51c75e10fb4f6b531671c5610a4437fb81fb609fe41f19cc4c7e2348daa9f1b2"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e26d15b6662a63db3e0bacaa613f120dc900d1328823a996505fca5cb684aea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f6f07e958039a8cd3928be4a5c9b46fde3e0d310a9b7f8d9a6296cc32b43961"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "353d68771afbb12c1d65b1a96dc78567a521979ff50f9b5a210fdd63bc94f123"
    sha256 cellar: :any,                 arm64_linux:       "45ea61c75f17b3b7009bc82a45433b1712470d8b9960c5924fe3de413d67fd9d"
    sha256 cellar: :any,                 x86_64_linux:      "a129b27149a4881f5ab7adfd3f4dbb1c6e4c4431d7d52421db2f8a1579da934d"
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
