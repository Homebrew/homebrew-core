require "language/node"

class CashCli < Formula
  desc "Convert currency rates directly from your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-4.0.0.tgz"
  sha256 "c8b1d437305bc4c492cb9b85bb1b91edb5cc74fa91bd007616746c6258dae6c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "a89b14a9c425998978afe98652ffd5c9d6f5b2536229fec6f34fa7ccdc59e767" => :catalina
    sha256 "c78661062dbc6e913d0f69f45af80af1f9967e50fe1eca86a95337ab16fac7ea" => :mojave
    sha256 "6b8215de6daf01c61e48bd46465be7ad9b400d4ec5ab514f5167bee787d6fa48" => :high_sierra
    sha256 "5941317cef9b92097c4b45df1e94b7b8d08e708d9813508ab3f42f55068541d3" => :sierra
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
