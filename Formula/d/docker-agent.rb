class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.73.0.tar.gz"
  sha256 "5410b8e150ef55e69b5d87eeb446a5c9df2a846fb5d018dd1665d60491eba8f0"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5796e3ccb47f84e0d29098a06725929d0f75ea9432b1b8336453767ab6d3464c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98912621f244f9bc640c83f5b93b47e4680b3584239c6462a25e3d9f39e1bada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda062653f88a3c2ca8bef2f4f7179e5d685876d45865349d28879e3c5d6a302"
    sha256 cellar: :any_skip_relocation, sonoma:        "6586d37fe873c76571430cd68364a5ef3b1a6cd9f8ad750d73f1373752dae89b"
    sha256 cellar: :any,                 arm64_linux:   "809ba382b910274744de948d3632ba047b731e2edc2c75a4c0cba5ef2eb3fa35"
    sha256 cellar: :any,                 x86_64_linux:  "40f9e1592e6ab081c4b55d7f725b23080fddc25137f74f2f4bd0c2a9f4a0a7ce"
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
