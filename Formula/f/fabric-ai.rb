class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.578.tar.gz"
  sha256 "31116695b48df0ccfa9ef7fb44c08879bac5703ddf20c2cff145f76289c2fc51"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9cdfbfd4158307755723545c340e169a9ebf2cc0618928aea2d042e57f5a0c35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9cdfbfd4158307755723545c340e169a9ebf2cc0618928aea2d042e57f5a0c35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9cdfbfd4158307755723545c340e169a9ebf2cc0618928aea2d042e57f5a0c35"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d44b92601f53884266ec57d0b26b5b95f574835f151612b3efd240f2cbf9c195"
    sha256 cellar: :any,                 x86_64_linux:      "7df03d67f9bdb6ad9c61298bcd6b5bb4d81a9f72b8beaa9bc74fbcfe93cffb4c"
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
