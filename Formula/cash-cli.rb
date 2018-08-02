require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal!"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-2.0.6.tgz"
  sha256 "a6d7e848a4ec51bb3bc51aa5317eb661e55d8f9130a368664580d3da11f2d335"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    raise "Test not implemented."
  end
end
