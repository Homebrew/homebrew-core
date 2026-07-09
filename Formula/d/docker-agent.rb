class DockerAgent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://docker.github.io/docker-agent/"
  url "https://github.com/docker/docker-agent/archive/refs/tags/v1.102.0.tar.gz"
  sha256 "a9b0e5a58c254effd41358bc8c892c207b3f91df4e3c6b780262670d8190198e"
  license "Apache-2.0"
  head "https://github.com/docker/docker-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef40cba26aa0b8f18e77b8511e10cd114d1582c965f1da26882c10d65b1e6fab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f3b1ca964f4c5954e25bd4240aefa712f9a90c39fab5e864c5dbba0895c0402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3595201e4ea08db9b74200b0edaad416b82f486599e2de9676dcc866d8639314"
    sha256 cellar: :any_skip_relocation, sonoma:        "474dda5bc717cdf056cb3f6f90df52789deb7cee093d74f09947b4c18f2d9ce2"
    sha256 cellar: :any,                 arm64_linux:   "8a277be9d87a9bfca061a063e3e6dc18ad945b4cc1d33db51c909e0325d9a502"
    sha256 cellar: :any,                 x86_64_linux:  "673e365f27f61f824ab74add36285021d8bb5ee0a6d0f16feb8b9fc39ab84e0d"
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
