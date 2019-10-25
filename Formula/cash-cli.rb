require "language/node"

class CashCli < Formula
  desc "Convert currency rates directly from your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-4.1.0.tgz"
  sha256 "8051d81e5c2d9e4a955561031b83b6bb0e6b2d92d385783fcd292176fb3a9358"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5823f1fbbfcb247a47b042139e347772a20d6aca063dc817c52a01e19651ec0" => :catalina
    sha256 "a6940ba84d6b04f2d7d40cd2c38de8d86943655128f5cd9e2cd2b25212e5cf9f" => :mojave
    sha256 "a559e91d0e34a5927c361410105697a8dfb765c3406606575d71e969b1741f4f" => :high_sierra
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
