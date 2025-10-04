class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "82a5c6297ba59ebfb3a1288bc3757306f88195b4812e8975e3fa4f8ebe557221"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c930bb4a35083d3bb2b27391fde4a68d9b1e673c4a12f3ccc473574a2e778426"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c930bb4a35083d3bb2b27391fde4a68d9b1e673c4a12f3ccc473574a2e778426"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c930bb4a35083d3bb2b27391fde4a68d9b1e673c4a12f3ccc473574a2e778426"
    sha256 cellar: :any_skip_relocation, sonoma:        "cce6dca90c949f985cdfa3b47bdb206c1853bc32a3fc26a2da2ae38c2cd8f7d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aadaebfaea1f0b3d6ce5f0bb5878b4bed5e76009309f6c7da1b39a9441eb177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28055d007c0a2dd808951d640b1a576c3f56ca8efc1d2bc0313a9099ed11bfbc"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?
    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", "completion")
  end

  test do
    (testpath/"agent.yaml").write <<~YAML
      version: "2"
      agents:
        root:
          model: openai/gpt-4o
    YAML

    assert_match("cagent version v#{version}", shell_output("#{bin}/cagent version"))
    assert_match(/must be set.*OPENAI_API_KEY/m, shell_output("#{bin}/cagent exec --dry-run agent.yaml 2>&1", 1))
  end
end
