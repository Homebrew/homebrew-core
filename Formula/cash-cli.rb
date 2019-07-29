require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-3.2.0.tgz"
  sha256 "a7f24628e8c8f61db3502c96296f1ea3e631a1725e212a932a38d2901ccfa452"

  bottle do
    cellar :any_skip_relocation
    sha256 "a28d5d5256bf0edc64fcb828490563fbeeb305632301198a9519481d438de866" => :mojave
    sha256 "d4f5ac27528cbc05e6ae13f240d5d63780667eb5f94409fce8a93e9f9581dcb9" => :high_sierra
    sha256 "9db9b06dd134c170cd8466eb60a60fd76664b4252a813988afedaa2396a32217" => :sierra
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
