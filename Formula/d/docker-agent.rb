class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.163.0.tar.gz"
  sha256 "24fb21b39133097248fe1acf925d0688ee66bbd4bce4af8ac48c99e088a5f43e"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2032620a0e87309d0a0721b95726c0160989fca20be18de851650b2151c2e433"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "952218c2fc3241925191197baa3e45c33a41c36f1b15a7894fdd5e87a2f0e472"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f3c33858a2138ea1a5269c90a2d2c1200880f664b5a643c90fad71df960605e"
    sha256 cellar: :any,                 arm64_linux:       "f3981af6bef984d83c12e9a69e1308e190d07fb8e4292900053bc017c97dcc8b"
    sha256 cellar: :any,                 x86_64_linux:      "4e2d8b58a76100c990948bc20ad917579a1a696812eebe555658ce28c8f09650"
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
