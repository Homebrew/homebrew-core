require "language/node"

class CashCli < Formula
  desc "Convert currency rates directly from your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-4.1.1.tgz"
  sha256 "5ef2b291c67e7eb822ce2ad9a280ce2b3974dd08b9e1ad0c40386e3f8cb3caa2"

  bottle do
    cellar :any_skip_relocation
    sha256 "64e360214ce8e9c46d4c8502084e03896c1a32ddc3d2c60f65d76bd3d281b1c4" => :catalina
    sha256 "3bfd94c6e4dfb280fa22486f1520d20ed75a8908a607a9bcdc9c1bc9092c1148" => :mojave
    sha256 "457068eb99627b414a958b4d87f607913b2db3285009e8a75df55511533cbc68" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Conversion of USD 100", shell_output("#{bin}/cash 100 USD PLN CHF")
  end
end
