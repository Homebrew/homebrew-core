class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "bc66eb8191d73ac51a3526d801decbd9f8087f9cc02a0c70d89767561d12a7bc"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e0be8573a62a83847673d6ed5e9c2ec8ac6e9d669462c90667ef9364421126e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cff3161705d695dc47b7e9672e76438c53f3dd096051cf77ee2420cec4c0b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d6ee6c8d7477d61e093b6c58bc955d15c55bfab20a85356b8afdb5d0497786b"
    sha256 cellar: :any_skip_relocation, sonoma:        "84ebe99697d23c39ee6b28897349a7b558232a4c5c27f99c7c0cd60c4893a318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "978819eff28254db84a862c05d873a6f7bae5ffc27c774aa4842c7b8017ec6f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a349df66c3c2b1502306f4f70dac29c6b6ee608e0fd728b9eedb14e5111225f5"
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
