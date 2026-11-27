class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.167.0.tar.gz"
  sha256 "fff2ac2edb1dec6d522fa95f6ccd92f283493b09daeb16f7f0833dd513f04607"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    manifest_sha256 "2d3c65fd2de7da561531dca3e1701f010ef231bcac174233c15e846fda15f8f8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "719c2e33f1d2da616c1df8da77b45c39fbaf060d6a8b41be45f2bf5f9921d2d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "078f161852e897652f70a9fa4c8d48cc124bb9d975ebcd38947642dd8f5bff6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "53fce3be88a4c56eee44e611c2ad8d082341c2289f6d355ba7f53e43643b1480"
    sha256 cellar: :any,                 arm64_linux:       "036f770d615f54d33f3e9f8753dcaa8adfa08c8f0f8a4f1edad5942f8b262945"
    sha256 cellar: :any,                 x86_64_linux:      "e9b971dd3eb14eafdba6625315c80fd3f8082874a7f6ccf723e59d65b0cac24c"
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
