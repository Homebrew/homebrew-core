class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.564.tar.gz"
  sha256 "5a3825e52f4ac9b3149b4e6a185ab1709e1fb1f953391898bc5f4238b6943b25"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bdff8e1472a3f6b0909f469b3235e7ea86273b759fe006802047b171b80e2fbd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bdff8e1472a3f6b0909f469b3235e7ea86273b759fe006802047b171b80e2fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bdff8e1472a3f6b0909f469b3235e7ea86273b759fe006802047b171b80e2fbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1577ff3dd8911dc0226326162381ab409d94a37102a38216d24ba93391936d8e"
    sha256 cellar: :any,                 x86_64_linux:      "59fbcc4422a3e1f1af59b95cf9d94fbcc6ae8766f8bd1a8acfdbec8bbf1a76e6"
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
