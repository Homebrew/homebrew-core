class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.579.tar.gz"
  sha256 "a1b97e0a2b5ad42792d06960b069d0bf84d6506c2264c1ca0a19d04417ade877"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d4f5d8b866cde72837aba485ea9956f9165975cd9e268758ba3d879a9e7b8ede"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d4f5d8b866cde72837aba485ea9956f9165975cd9e268758ba3d879a9e7b8ede"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d4f5d8b866cde72837aba485ea9956f9165975cd9e268758ba3d879a9e7b8ede"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7522dda381341297ab4172736405fdba27df1f15750cf417b3f71f7dabee5ad9"
    sha256 cellar: :any,                 x86_64_linux:      "0b213eb7e91f29a6843f65f6d56bd764a9bc5b71ac1822b99879676c7d09ba86"
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
