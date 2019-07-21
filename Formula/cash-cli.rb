require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-3.1.2.tgz"
  sha256 "8c9875d60fc4d3b5cb1a9dda182b53c42b4ccb574f83317e51e9f608e1106fe3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d87cfdc7efd00f2f828c542c1159193a74c309e4c3df2171734f91f03a2c213" => :mojave
    sha256 "801643fe0ab824fcd52a88dc9f1eb3ccd4d2fb25d139280fefaf0ed9914cf61a" => :high_sierra
    sha256 "a49fdfb1bb3d4181744ee05d951eb5c1379f8dbb260958256b6856d9554e8192" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Saved API key to", shell_output("#{bin}/cash --key 11111111111111111111111111111111")
  end
end
