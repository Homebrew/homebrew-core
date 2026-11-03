class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.156.2.tar.gz"
  sha256 "49d4215ed88070794c235ae4f3e48c2b57103fe6db3c9739802bbb98832c5292"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad3ff380c60d4236c61ff9791a76b0b4b94dc5a607bec0f8c7670c5981742742"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70c416e8c09533f8315138d1055e9cbf028b3ef586f6ad50a19bd41729c39016"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "672cca5270a3c86701fbf34e52dfbfb8239582baf5cb40f56c772df2772b404e"
    sha256 cellar: :any,                 arm64_linux:       "f79b0a52f5deb46b62875f9e9a30868266d58619bc6aeb564960bc9a2e87938b"
    sha256 cellar: :any,                 x86_64_linux:      "90aa1317c934e3089169a657dd7d87903cfb7ff35b77b1711645c29539b9a8e6"
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
