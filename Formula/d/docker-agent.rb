class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.50.0.tar.gz"
  sha256 "04941cd3fc077f06f0d43d7e1c7ce7e69a5bb1a184d93e7380c71892da0bfd88"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab9a35604129d337f554ffc3a2ba2a0b1005c96a3648134ab36711570ed9090b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "064da11eda21e8ea33de680286e24627f991669ef3f37ec16f7d49da06b10875"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4067e744d98c7ec147044efde148d8bcab755ace6100b80530ce1ff0f7668c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9ae8a2d384663b16b22a2398a2d5f56298532bcb63eb81e5084305b1f2c269e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b50148dd3183a8a3ad07669d0029f08c75a7818af4e42180aa4e9804cc128157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b57cd76b62bced6d6c607ccea535ef1b884996b7f250353ecc137e001e6b6c"
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
