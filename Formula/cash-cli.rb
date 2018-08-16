require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-2.0.7.tgz"
  sha256 "f5dc22657510ef80ceb2dc7da38fd88da682d32abac5a2be129fccf968c68cb6"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Conversion of INR 100", shell_output("#{bin}/cash 100 INR USD GBP")
  end
end
