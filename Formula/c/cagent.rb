class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "3e711844e7d291b068c742d2cbb559e2911c15be341e5428eff0f0d515fb1883"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "684a2cd9e057172c283e32e17c2ce7e39e423a1e9977912eeb5d24dbcc093f17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b80d904c29ad61961054e79234c4a82bfaab7c31041c76699a929833fde9e0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fb34bec36012e0235712604690a2972465a1b572f8d6d905e825f7581e799b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4baa17d51e4e368459ec71b187f40634e1eb65dec905aa43311784667883f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72e829d45a50d5cd5a34e10c737a98924cc3e67d1466844104ce5d6dbbf73d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d33646ac43444c18bddd3a3216f60a3a9b1cb3f0a121bc9fbbafb62c726cc64a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/docker/cagent/pkg/version.Version=v#{version}
      -X github.com/docker/cagent/pkg/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"cagent", shell_parameter_format: :cobra)
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
