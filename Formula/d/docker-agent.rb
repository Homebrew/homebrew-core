class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.49.2.tar.gz"
  sha256 "b220ef3960c6e36c408c08820e1eed90c41f213c12f7ddeaf2cba47aa6d96936"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "516ac3673c2bcac3d63ec8f4c67d15461edf5f5809f1d350f0067dda9fd5bd8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9afb64af44cba4d086a680a3770d345200d80f1299c39aed7c6038bbf849f5f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3531834898213444525c775ff3c2fa509fa836b6416eea47712b639eeaaeaa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "76b4e8f4c2b7ca0f2ee0d3ab3e51de53e6c0c37a39aa9fcb386f999e835aed7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c438fe0a97b739b5f88734662cb6b59321f9d495ef8c576d72e8e27c0dc9bf3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83bbd605b643bda03bfd6e9c516cedf76d8f23853f46487f9553f84464e5d4f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
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
