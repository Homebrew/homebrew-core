class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.563.tar.gz"
  sha256 "195b6f8f2830abb37ad0381edcb81cd973ca1a317d9ab6092b439813cac3cac2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a5373d7a4c24ba7128d7bf4552cc48d83b6c362a07235fa0282a536512e7228"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a5373d7a4c24ba7128d7bf4552cc48d83b6c362a07235fa0282a536512e7228"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a5373d7a4c24ba7128d7bf4552cc48d83b6c362a07235fa0282a536512e7228"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dc4fd8e20c9b40a9c48e3bf72d9e44b3a85663378532eef9c1a3e3e5f9f44c76"
    sha256 cellar: :any,                 x86_64_linux:      "6e23208f8be395a724bd21577e1f186232cfd73fd8a7baa797722dcbafc41c41"
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
