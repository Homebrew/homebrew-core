class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.573.tar.gz"
  sha256 "ccfdc56d033cd51925f55ca716e5242d331c1c600559a39b1d4f17959eefc06a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "060e03a04634964c002bdd8a83e447c5b62ff3c34ec758eb03c26b3b7033cbf0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "060e03a04634964c002bdd8a83e447c5b62ff3c34ec758eb03c26b3b7033cbf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "060e03a04634964c002bdd8a83e447c5b62ff3c34ec758eb03c26b3b7033cbf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a4db0f84ef5435d123b7cfa928422b7150afcd7a8adf04ff8b3fdd2a032c3ad"
    sha256 cellar: :any,                 x86_64_linux:      "029f1d67c5b998da7efce88dd10213a62df5eb7f94b52ceeb51eeb19b56cd2f1"
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
