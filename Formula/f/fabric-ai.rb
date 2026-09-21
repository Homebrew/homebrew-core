class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.478.tar.gz"
  sha256 "d709cbd036bc66ce69423e03f7d3ff2b108a302e4f65c4f03db6e63921cef1cc"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "edc05832386ed1bb097a49ddde77fda613eb4e079a63758b11a334b6c5701384"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edc05832386ed1bb097a49ddde77fda613eb4e079a63758b11a334b6c5701384"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edc05832386ed1bb097a49ddde77fda613eb4e079a63758b11a334b6c5701384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "edc05832386ed1bb097a49ddde77fda613eb4e079a63758b11a334b6c5701384"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "46af6608a01e12d60f195f69ef702536eb78a441c0adffd05a88d0c6420678dd"
    sha256 cellar: :any,                 x86_64_linux:      "d940a2b5669d706e8cd57bfe69b396d22b9fd5a56e1c59c407aa4f3c50e699de"
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
