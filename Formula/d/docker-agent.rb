class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.157.2.tar.gz"
  sha256 "a292ad0e90718b21710d881cc50441dbbd8047096536cfca5b660c1fbfa78583"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c4de4e225f3c2a345c7d0c54aafcae2f75fde47a3ca90c9be5e724bbf1d46dbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75fd5e1be7f2c771dc141a43be21c2989efa0fbf14254b3dcae66b1644f41c4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9ed342503a2236ac7428d6938f4f32a4df74747c648f7649f2f61132ea96976b"
    sha256 cellar: :any,                 arm64_linux:       "491163814362e1796fbeb2d86c3835f8fd424f4a92bd82c1a4a8fb0db39419b2"
    sha256 cellar: :any,                 x86_64_linux:      "8918c76169c92bccfd0643a158fa90ea45108e82836c39d72b5ff2524239d825"
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
