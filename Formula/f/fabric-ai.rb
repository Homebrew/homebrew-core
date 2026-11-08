class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.567.tar.gz"
  sha256 "2ab8bdfa1d05bc2ccb7a393aa4abd1eff8248367c649b1226130c2acccf2d17e"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3938c31454302eb7a942d818a658dfab10593c86abce0f3a3d2bdfaafe48a21c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3938c31454302eb7a942d818a658dfab10593c86abce0f3a3d2bdfaafe48a21c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3938c31454302eb7a942d818a658dfab10593c86abce0f3a3d2bdfaafe48a21c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6d8d7dea1af826898bfdf036d36140806d7751916213fab71f66c6f3970df987"
    sha256 cellar: :any,                 x86_64_linux:      "a20499ab2be8cd6fb45c037bce5a6da90a00e0120768b9a3320510b5a507fb01"
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
