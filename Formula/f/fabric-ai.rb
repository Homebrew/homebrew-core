class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.573.tar.gz"
  sha256 "ccfdc56d033cd51925f55ca716e5242d331c1c600559a39b1d4f17959eefc06a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8bd82d949baf6187405b2fe81dcfbb718529c07d8002308a46dd20fdfbb41db6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8bd82d949baf6187405b2fe81dcfbb718529c07d8002308a46dd20fdfbb41db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bd82d949baf6187405b2fe81dcfbb718529c07d8002308a46dd20fdfbb41db6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "78340a7957ee84b39a0a283209a04ba4acebe9b87186c85843cfbea585c40d3a"
    sha256 cellar: :any,                 x86_64_linux:      "e20cb4d81dab55ab6126da492220e79e9b9e57416b6b11cf330c97741d1c84c6"
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
