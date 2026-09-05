class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.477.tar.gz"
  sha256 "a57ec3c7a846c5e5168c91bc06cb737c4c83817a9a427ba3b74f36dc93caad1c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efaea695638f07d0def55646d19825ee69b431c743508dd8b2eda13bc5d5525a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efaea695638f07d0def55646d19825ee69b431c743508dd8b2eda13bc5d5525a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efaea695638f07d0def55646d19825ee69b431c743508dd8b2eda13bc5d5525a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c67c6097fc778c79828a24d16415e402779952a904fc96f2aa898bf3235f88d8"
    sha256 cellar: :any,                 x86_64_linux:  "bd1fba4e7e2b6c1626dd280e1a841d34cff39b3d3eabf9e8a3ffca7350553621"
  end

  depends_on "go" => :build

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
