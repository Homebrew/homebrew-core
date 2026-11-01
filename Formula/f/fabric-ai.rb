class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.561.tar.gz"
  sha256 "55cb5d08b5efaa076c77296166c2f05f0d50575f67a242b62c00d5fe81f5132f"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dae0a249792c521e04c0a7a76b73b292e0eb88d60220b0462de014ee9ce2a12c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dae0a249792c521e04c0a7a76b73b292e0eb88d60220b0462de014ee9ce2a12c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dae0a249792c521e04c0a7a76b73b292e0eb88d60220b0462de014ee9ce2a12c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c8676cc9fb8fa447335d6aabced587008948dca6e533c5f0648c00727bfba597"
    sha256 cellar: :any,                 x86_64_linux:      "d74610b1c7df067e674153a5745145f8152ce299031bc4122196c848cc06781f"
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
