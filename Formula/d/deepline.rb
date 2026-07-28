class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.294.tgz"
  sha256 "45543eee22acfce8ff8e2494c5fc605ecc37ff067d5fd44ce6f21c49d2bc3da8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d91c2c54db0ae8f2e29478309908da07d62649035655f9dec56350d9ff7164d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d91c2c54db0ae8f2e29478309908da07d62649035655f9dec56350d9ff7164d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d91c2c54db0ae8f2e29478309908da07d62649035655f9dec56350d9ff7164d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc9e08c6d186b45b9a5e261fc213cdfeacd93c060e3ee262358fa3c6d037b49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28018fb4c75d3ca022ae01f8c65fc0341e5323431fe4fd8e05a47d66219fbdc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fc4fc6d9dabdec2a513dc0e5d45124ecc0ee763354088d0b94374093a82a043"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
