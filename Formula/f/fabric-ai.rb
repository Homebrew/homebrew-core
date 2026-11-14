class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.575.tar.gz"
  sha256 "c670c51cd6635b9289ba0faaaf3adc3ab1331fad853fdfe6b2d89a0b06ef34cd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70d085166818cc38554af1159bceffb427e5b925a39b7e224d33f253e54b6148"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70d085166818cc38554af1159bceffb427e5b925a39b7e224d33f253e54b6148"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70d085166818cc38554af1159bceffb427e5b925a39b7e224d33f253e54b6148"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1457f8d4690192d3f279aa7954f8a87997c98e3eb5d07f95888408601825d7dc"
    sha256 cellar: :any,                 x86_64_linux:      "0a21f6accfc95c491aa3ab86d032811df4206181900317c9e19c6aa0904eee08"
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
