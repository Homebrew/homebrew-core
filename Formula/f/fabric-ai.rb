class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.443.tar.gz"
  sha256 "ecd3b5383b0b4097add58be5d399b9e8865fa3a0e40409f099786b26199e7bda"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2251f3b013817272fdca93f1f49530df04e797709278794b2dfef8b531e856a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2251f3b013817272fdca93f1f49530df04e797709278794b2dfef8b531e856a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2251f3b013817272fdca93f1f49530df04e797709278794b2dfef8b531e856a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4ecfdeca1ecdb7bc62110b96f202645e5533716507c85899987219934cd85f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d717ec673be8ae838ca1f1c74b9f34f472953d863f42df7c226a528dccb5e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b2be2e8fcad4a9cb4e8d57688903a3ad07a0cbad833f0401fc3e95f8c88d26f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
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
