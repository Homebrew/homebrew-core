class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.115.0.tar.gz"
  sha256 "0478e9f242604a5ffc5bdef24d3116d11904335d5fb4de84b61c774a17fb8fef"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1c8ca8b824b5299de1ea9c1286c2efa263e52643465b09f65a60481f8386089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad901474233fbdafb279bbf036ff94919436a0157f39c571fd9753030e85bf60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1b8d82cd3b319ababfd7f26d88587f0c2ebad12406186e0b6e82930f48e9585"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c20507091408541a9c06dbdd79186d4eccb3b83853e84258b47f82e8802157"
    sha256 cellar: :any,                 arm64_linux:   "dacd4101fa23dfcf3dc4b06f61b2360a8382c7fbde396320e381f25b0a6ff2ee"
    sha256 cellar: :any,                 x86_64_linux:  "957b339d1e1f59aeb783234bb3f731c1c716a672dd4f5cbc797b1c9c7069ac0c"
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
