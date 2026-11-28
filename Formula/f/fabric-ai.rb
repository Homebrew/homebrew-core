class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.584.tar.gz"
  sha256 "49ffd4dfa3e141592193112352a64832e385db585f1c8b6ea053324becf50afd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    manifest_sha256 "f569424d1d43cd97166cd34d388d79d8374678a715e7456e69ee2923e821be53"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "473b2f6a3258de472e8fddf916ee7d222ed5a00308cdb57e88eb3faace49c463"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "473b2f6a3258de472e8fddf916ee7d222ed5a00308cdb57e88eb3faace49c463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "473b2f6a3258de472e8fddf916ee7d222ed5a00308cdb57e88eb3faace49c463"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3670dab6b27a7a11289472751e1adde5a1b3ca8d7243700c83dc0b0b0dd8614f"
    sha256 cellar: :any,                 x86_64_linux:      "9a663fbca351750ef20c89b1de5615ff345fb23a17473cc7e380b6939fc9026f"
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
