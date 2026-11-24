class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.165.0.tar.gz"
  sha256 "63ab68fa3a797f754b35211c5964d9967aa598555d8ce6f56b6aaf300c5f4fe3"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    manifest_sha256 "dd87ce8e2b66bcf8d58565809b6f8fb8201373bc943db0dcf53d5cd0338f3dea"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9619ea19985088a4d5d43eb7f28c87fcce73a5180dc82c58337daa656781b67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "baa39aabfc46caed8291e6f9b256b8e63bd37609689ec6b216bb6c0e04646bb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3031b3eab8eca946acc82c2caa2b8f4530255df1eb7fee83b6d8aef100914b2"
    sha256 cellar: :any,                 arm64_linux:       "623559581ad0d1bf90e4cb362fac75ae08f7730e6a9bfe88c343378af4f957c2"
    sha256 cellar: :any,                 x86_64_linux:      "664431ce15e1c17c9dbc1ab0b5c59342344996dc6646231bdf1b88f92920e64f"
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
