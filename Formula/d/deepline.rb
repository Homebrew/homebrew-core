class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.3.20.tgz"
  sha256 "8bdafe34c330517ccb3877f3e9c4d0bbe82007982b77062591e4124586768961"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83c790e48ea431db0f4b0a3e0b36098d62443aa9c2c1ed7466696fbc30cc24c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83c790e48ea431db0f4b0a3e0b36098d62443aa9c2c1ed7466696fbc30cc24c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83c790e48ea431db0f4b0a3e0b36098d62443aa9c2c1ed7466696fbc30cc24c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f7e690193ddfc1de7e14d1f607b3ec16c92262d9007fd912efa7f0b694638e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76344c3763ee3e16d39819756b4aaf37abfd6ecca4ee56856ec709d86a3ccdbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1579c5573a515dffd309d4fbcc9f25c492c6577f38067b66154aeeef49fcabae"
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
