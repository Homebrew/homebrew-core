class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.133.0.tar.gz"
  sha256 "dba6ab2d11f7261eb275c172ee28f739bd7cc4f283dd92b59c08ed91ce6a0805"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d7ba4414ad9969a6dff9c7f48b8cbfa5e485dc78821ca66d9821829a526638c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7ea2d62bad1f3213c11c6b8bcff68436cdbcfaf9701a70e02c503b16857d258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "763a701a7e355b14602f4cf3d0fae2f953210e5a61748332a3b51540e9b8a194"
    sha256 cellar: :any,                 arm64_linux:   "c05afadbe8c43c99bdb4e0c4c189eed6e3eab42997ff64c9ab735d042bf6278e"
    sha256 cellar: :any,                 x86_64_linux:  "04ed52ce472c57cca60bf8413bd13b49719053e0b391dd76c4ff57fe90105ec6"
  end

  depends_on "go" => :build

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
