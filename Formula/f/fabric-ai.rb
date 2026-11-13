class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.571.tar.gz"
  sha256 "cd1bf7b1bdcead9c09e848271a1f6f56df0e31979abbe7a6a30069ea9443fa93"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce3a27dabfa04ccd635235b2141866a5ee8ebfcbf7784f5212b79f5d5f4971fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce3a27dabfa04ccd635235b2141866a5ee8ebfcbf7784f5212b79f5d5f4971fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ce3a27dabfa04ccd635235b2141866a5ee8ebfcbf7784f5212b79f5d5f4971fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23dec11af7959deb93ffb29c09d22bc92bce3abdcb326fd0a9277c9ccdac0158"
    sha256 cellar: :any,                 x86_64_linux:      "c252169b423d1d55a003e1568e8dcb128c59ee03eb14c7f7796cf011751cc2e3"
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
