class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.506.tar.gz"
  sha256 "29ac887977eeaa9acb3093bb1cf5511e9cd9a0feb55f27d54ba3462f4f75cf96"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5449204110651a8b1cc91fe72138cb8fbd2e2cf442b9cc3e4574790d66e3b71f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5449204110651a8b1cc91fe72138cb8fbd2e2cf442b9cc3e4574790d66e3b71f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5449204110651a8b1cc91fe72138cb8fbd2e2cf442b9cc3e4574790d66e3b71f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd2165f8f267624b4aa814325c6efae653095c01b113a8ac11acce699213e3a1"
    sha256 cellar: :any,                 x86_64_linux:      "f73cc3e9f858f713db53599945915688132eed7587a28a55f6702c5a840ff3fd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
