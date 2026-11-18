class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.578.tar.gz"
  sha256 "31116695b48df0ccfa9ef7fb44c08879bac5703ddf20c2cff145f76289c2fc51"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "784a3b095781a9599815ec76229357df400f799d3534c34a828789483590d50a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "784a3b095781a9599815ec76229357df400f799d3534c34a828789483590d50a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "784a3b095781a9599815ec76229357df400f799d3534c34a828789483590d50a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a56a050b3d63df41ae788e6ce73be58ace3bc4fb8856b48fe35664656b179687"
    sha256 cellar: :any,                 x86_64_linux:      "b2653fcb3dd18b96b86346078536ec751a416491010bfe89536cfe001ffa2b8b"
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
