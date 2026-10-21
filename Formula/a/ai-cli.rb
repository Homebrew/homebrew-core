class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.7.0.tgz"
  sha256 "d51b19346e33fe5825a7a46fbd20dbb0fa7f210addaa763704f785d738d2c99a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bf68071f6fdc1bf0b58d18e9c5f13e1134d84227cf9c0d0a87ad8f1bab49b58a"
    sha256 cellar: :any, arm64_tahoe:       "bf68071f6fdc1bf0b58d18e9c5f13e1134d84227cf9c0d0a87ad8f1bab49b58a"
    sha256 cellar: :any, arm64_sequoia:     "bf68071f6fdc1bf0b58d18e9c5f13e1134d84227cf9c0d0a87ad8f1bab49b58a"
    sha256 cellar: :any, arm64_linux:       "1d066a235975bd8d69495ddb99849b92dc11e880f5a0186e5269e900d2a86c28"
    sha256 cellar: :any, x86_64_linux:      "f9dcc9dfe377819cab7130947ae7af80c80fc2848bb776123393bd518ed7167a"
  end

  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end
