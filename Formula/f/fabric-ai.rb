class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.568.tar.gz"
  sha256 "e6fca69a1575b23e308032d8ac163ffec1bdad1803889dc2d2c257ea581fcdde"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "409e5b0b3323133d85aa8a40d84a556fc433196c874844ff369bdf536afa83d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "409e5b0b3323133d85aa8a40d84a556fc433196c874844ff369bdf536afa83d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "409e5b0b3323133d85aa8a40d84a556fc433196c874844ff369bdf536afa83d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eeb7cbd7fdd3332983c696ccabf7edd208b0e6e3dbd15b29cdd46db7fdc11dcf"
    sha256 cellar: :any,                 x86_64_linux:      "6f1bcb98f4fe75dd14a5e6e889a3172308357bb53c1fff506ceb316bbaac84ff"
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
