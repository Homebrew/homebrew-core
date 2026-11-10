class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.159.0.tar.gz"
  sha256 "0903fa9dcebad0faaebd8f8053223cf4599a37ff6ace0dced1070c8889731a73"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f70da40a49f9f6c3000d378db58d3e094d3156e9a7c2005236736cdd997f024"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68b97a62ab95ad3db1d8270a6351f35bc7666a74acb296b11c1db069d540af3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f9eba5ff1801c74156dcf66ee7087497ad1ace6b6f14632976ee0b3c3265c3f"
    sha256 cellar: :any,                 arm64_linux:       "272c8e58ac0fef3731b47c9b68d47893a39766009f02019da73a33b05885ecb5"
    sha256 cellar: :any,                 x86_64_linux:      "efa37ffd6e001f52f1fa297ab1a09b25e8e0a9c74ebdcb58a1410544c1e337da"
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
