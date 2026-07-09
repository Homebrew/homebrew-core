class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.4.2.tgz"
  sha256 "1552fe238facb166cb09dcd626e31e53925458196e74bdbd876a2c97369c4f80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eda295807aafeba48ac65a30afa500eabe3c82f018f56d72d72cd7fbb97244c4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
