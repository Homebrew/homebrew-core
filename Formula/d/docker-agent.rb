class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.158.0.tar.gz"
  sha256 "559190bc5384d1944399870d1fd62fa0b664c7ce1b2aa175cbda4f21fb3f2337"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ba2cc01af49d65774db702939a69d04af2007b7185b11913a2275c1f64b5de3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "853d8ed19d07310e4fce3896c4e17295eb0e8ae2a3bd0a0bce2158ed92630716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58470c2ec8564edd4d4c6e40b9e7238a67c373eafc523b2bab9ea38b55be6478"
    sha256 cellar: :any,                 arm64_linux:       "cde813ade251453b696f7e6b4ce207bfe1c21e741c8848fc2943ff33344ce8d2"
    sha256 cellar: :any,                 x86_64_linux:      "a5e6a5214974f8171910831370c615c239e44ce0d290040b9a1bf0607785dc9d"
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
