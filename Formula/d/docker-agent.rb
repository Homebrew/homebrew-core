class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.166.0.tar.gz"
  sha256 "2cd8beda6d7b8647180e1d85408db6117e2c2eea6cffd73f37d9206f99cdbcc1"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    manifest_sha256 "550c3527ba1913fc375f819feaa5cd15e7c9f463a7deecefd85a2184931658b1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9926c9eec5193f0d03f372713e233f0b32b95cb2086c8fa7b6c992169b6e36a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c20e9b789483d62c2e2ec49be8103ceb830e5b31b2bf0d6455b19bfcd4a51a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8651f58947a973c8d3ce1da7d64fe768aa2f054770752d6ef6777c7efe9dba9"
    sha256 cellar: :any,                 arm64_linux:       "c1880d14020a8199e1c7c0eda808714ae2afceea90c3800b895c91b593618064"
    sha256 cellar: :any,                 x86_64_linux:      "61054158409b7745956699ddca89bd9f8bc3685c444f366585736d4515b98113"
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
