class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.459.tar.gz"
  sha256 "db341f2d9cc35f3b0bae3e0f344940f2bda4b4050c7b18cf55987ceeb9fc5412"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3f206d1c2ed59bacf257b4ef835c78b5bd4bb929ac7bbe2418f550451f4c007"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3f206d1c2ed59bacf257b4ef835c78b5bd4bb929ac7bbe2418f550451f4c007"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3f206d1c2ed59bacf257b4ef835c78b5bd4bb929ac7bbe2418f550451f4c007"
    sha256 cellar: :any_skip_relocation, sonoma:        "4df8c7077c6737dc42b2a0a65745f6f6e35e39a806488c8b36cbea771910dc68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c00d121f13030540c3d7d12a80108c84c409b22acacceedc9ed9b99c22eb6336"
    sha256 cellar: :any,                 x86_64_linux:  "11a28cff3ba400aa738171a63d1f198067f999a8e5ef1d57aee75ce94eeff9d3"
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
