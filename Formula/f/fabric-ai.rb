class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.551.tar.gz"
  sha256 "455f023c8fac261c09aee77ef4fac2c4fa828a7523e47d1f9bd43f04fc707fb9"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1af5a41dbfb470c2fd5cc8e506a252ddbdb5c5a09a5ec8992816f0fbc300b5f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1af5a41dbfb470c2fd5cc8e506a252ddbdb5c5a09a5ec8992816f0fbc300b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1af5a41dbfb470c2fd5cc8e506a252ddbdb5c5a09a5ec8992816f0fbc300b5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b37bc170ecaed65e74d6dad62f7a44adcd881b9c948d676b6dfd35e798b7ecc"
    sha256 cellar: :any,                 x86_64_linux:      "f2e3efb67a76a045af8a2528d6b436826089426de329c6d2f1638ae86c3e9851"
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
