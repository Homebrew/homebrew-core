class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.531.tar.gz"
  sha256 "449dbf6ec1280821f32a17bd48d00541ae44550798ece1e1695218c97ef005ac"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f441510f280106d54f6128daa815c67d8c26a0836ca302f3e4e7870254f8293e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f441510f280106d54f6128daa815c67d8c26a0836ca302f3e4e7870254f8293e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f441510f280106d54f6128daa815c67d8c26a0836ca302f3e4e7870254f8293e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ae0827299377466c9660f4bcafb06cbd373cf773a3efd344077752db1ae014b4"
    sha256 cellar: :any,                 x86_64_linux:      "3cce89b7817705702adc7dc17006ae7a4a5279443545cb508d642ce4742a49ce"
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
