class Cagent < Formula
  desc "Agent Builder and Runtime by Docker Engineering"
  homepage "https://github.com/docker/cagent"
  url "https://github.com/docker/cagent/archive/refs/tags/v1.19.4.tar.gz"
  sha256 "9ca30fdbaaa8cd6d62df3b0d07c60c7dc69e3a7dda937bbeacc64566f0746327"
  license "Apache-2.0"
  head "https://github.com/docker/cagent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ee5444a6430fc4bfa293427f6561ca1576f8d66d6baf216b7f030c3627ddeb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca3136c66a4119870fbd95d906b6a6a16c144cff1b239cba4a395ffda80d78e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "119bc1a6e8563997ef47fa6feb52daf607399432181f8f2c13a20c7ab9835b8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d4a173c7497d812870d451934658c3293f1231ee28c144de7104e206f54ec7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8919efa0af1b3f2889642cb90e5bb144d09f22b4352e50b870aec6c679db8a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07e0d14004b0cfd5d5dc21b96914407e4ca3716b3e91c78b58e74fd64eb1fdb4"
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
