class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.585.tar.gz"
  sha256 "98150cfe32679f2c9b09f4ac17de71e1e7bfa764a5c4647f36ed58edc1a8a05c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    manifest_sha256 "f62cee4087f0042ac41412e23f2f474d04d81dd2845bf32cec628b780bb61fc0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "803e4558845d359ea0cacbd68667df5a797450a5a803fc5426bae4ecd6756681"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "803e4558845d359ea0cacbd68667df5a797450a5a803fc5426bae4ecd6756681"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "803e4558845d359ea0cacbd68667df5a797450a5a803fc5426bae4ecd6756681"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb813eedf8f71c68eec922bfbb530cf876a5d6f8a998e57ba13a030127496236"
    sha256 cellar: :any,                 x86_64_linux:      "41e92696b73e68c4c28c418e8f2d40f96db01adb0cd0e5f422657583cce29bc7"
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
