class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "2012743914fc48cfabfa74821c5de4dff18f55e864a7f2afe59e8b4ec79770a9"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f3fb5dd68d2653459ab7db02e43d0f185449f001afc9791edb22afaec6a7107"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cece691b618b16eca1588fbcdb7e2eded6d018ecdedb7abef0f14a0bcffa5611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3e194056c3e455964d7afddd2e56aa46d0a0b32cbeb74069228c3e7dc4cdcc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "18258c4d8ec93bac9a89373d2c0e3736a79ff087a62a0fc31f8f18f120592edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06394678ba010144ae25e371834194eaafcb632d18fa86ebd95fccdd7583c977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c7faf84ce929374593ab25ffc128cdfcd12ec3104ee09067e88d27f87058376"
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
