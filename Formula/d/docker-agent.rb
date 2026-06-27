class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.88.1.tar.gz"
  sha256 "7819c21f44ae043c62a12d86e792ecddf7563e14a9655e10e51b3cc209cf5508"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46973274e87a97d976ae9e00431b8368d29b45224eef791f088afab60ce544fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59b0b1bb6b8bee05a2cc5f5323f3fb57b8c2d6be67c55b4671c338dc75e98ad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3385dae9636a8db09c044728e1e821eee2eab3aa94a45b18a0e1cbcd8429d64f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5e0ffed0434238c451430aae9eec3fd69e7d18bab2284a63203e861c0d9c206"
    sha256 cellar: :any,                 arm64_linux:   "01bade915ed8ea1e9f141584c1b5a0ec14799d78de706b21208ef544183c9e87"
    sha256 cellar: :any,                 x86_64_linux:  "e8c9676f62ca903c41c859ebec69a90cbb955fb66c4c020fc2915a75b063c429"
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
