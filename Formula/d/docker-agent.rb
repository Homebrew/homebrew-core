class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "f16fb76c6c9b3fe4679c8aed393fcbf2f49861e166787bd5dfee4ab1b76ca344"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5a8b58744f37d837e216197852650d0212968fc1cfb54db7ef6428a937d2053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5632eadb2d58640ca9ebf794ee639e2facc1275073e48d8923c5d705eef1ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f708e90ab12b6b5731b7f0097be603b524ad8b41db5e049a6a0d33ad0c2a12c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "023ceacf0d3867f26398e50128f9c74f6b1dc39215a300fe4f0910ffe1c595ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c1afff53f7082d34b76e3a6ab3475ff4cad4cc5ae3f677454246e86fe053739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4469ae36a7c11bab49c19a85e579b65256de83f7bd9bed8e8c3e906691dc8a3e"
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
