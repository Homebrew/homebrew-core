class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.576.tar.gz"
  sha256 "ae57f539be633e87f4fe4f083d90d915e04caa548390ff08432cc5f9ccfd68da"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33d1ffb6fd3e7cd5b52ba477d32859ed98b9973d5860cf8f2e1b8fc84def4149"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33d1ffb6fd3e7cd5b52ba477d32859ed98b9973d5860cf8f2e1b8fc84def4149"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33d1ffb6fd3e7cd5b52ba477d32859ed98b9973d5860cf8f2e1b8fc84def4149"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "292746009fe1df3140c805681b09c4aad66b3d9986fccaf7bd23795382bab9ff"
    sha256 cellar: :any,                 x86_64_linux:      "d03d9dccc22ba5d5ca0898665e8ab2687fe2410cb374947a048ba4bc1bc9c356"
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
