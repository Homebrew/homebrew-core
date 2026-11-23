class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.164.0.tar.gz"
  sha256 "057eb3d856dc59bddfb5cd7675e35c1a5bb8a7f6bdb0f2d7d5f4b4d0dae6bc19"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    manifest_sha256 "29aa7f338e955b58ce903d3760d9c1304c9a602d681fe81590304862cb9f9468"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2594c651ba4075981e139b4d6c668ab00d0856207501744cd8c3a1a11efaec99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bba6960f4643f03ae7342c17cfd44f909ac08edcbb484870145651f92d212947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ab4a0388d12b484a4cd3525ff2f9b83c2e6056dc4b0e8f522b8ea46c6ac196d"
    sha256 cellar: :any,                 arm64_linux:       "732d1ff11db6ebd2fd507ac1cd30c83dc20c377fe00afe7e33e47a68a6cf57b3"
    sha256 cellar: :any,                 x86_64_linux:      "1ece01123599f93062fbe571ccfdbf6d66f867aed4183ddf9acea5fd5290d136"
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
