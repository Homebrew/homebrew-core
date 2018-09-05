require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-2.0.7.tgz"
  sha256 "f5dc22657510ef80ceb2dc7da38fd88da682d32abac5a2be129fccf968c68cb6"

  bottle do
    cellar :any_skip_relocation
    sha256 "2860ba578814b3b4a2928e705f6214be6a947f5c078ce9dd1feb53d196455cd3" => :mojave
    sha256 "82ce4c7f0b52ea68df08614453a5d6c5ead0a46bafcd02bc6b3db13dfc355fb3" => :high_sierra
    sha256 "eccf8aa349797727e8332b7f7990000d49edd3ca5d0de991b8c6b23911ed9f81" => :sierra
    sha256 "3b353f58868294256d20c00fff8ee2b7af9dab8281bdeebeace7d59ced2e103a" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Conversion of INR 100", shell_output("#{bin}/cash 100 INR USD GBP")
  end
end
