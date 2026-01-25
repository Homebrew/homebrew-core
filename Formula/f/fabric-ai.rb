class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.394.tar.gz"
  sha256 "a6b6da773a1cd90982081d1d3579ec203b09b295a994846f02035b09785c98bf"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b676b0bc11fd23616aa4984bb6b88e2be16b144357fc1777e9727f1269772530"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b676b0bc11fd23616aa4984bb6b88e2be16b144357fc1777e9727f1269772530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b676b0bc11fd23616aa4984bb6b88e2be16b144357fc1777e9727f1269772530"
    sha256 cellar: :any_skip_relocation, sonoma:        "39facacf2e764b30c748cb8c4cdba208c51a687f9d76e4236e052de8c3d422ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e895f56988864fef326e4ea65cd3d0fe12378e9b1ae887e71bbd711819f38507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fb494be64be7bc25d63de5d749be1aac5d3f16f3b60bfba3af6ca242de8afa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
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
