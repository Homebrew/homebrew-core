require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-3.0.0.tgz"
  sha256 "35990d2763a62bc08cb1f8c2aa0730b4463d41c84483cb40514ed418d3dc4283"

  bottle do
    cellar :any_skip_relocation
    sha256 "98fee94b992b289ab84a08b9ea43e9587e8fa86e75c294a8c8b7717b20bdd9da" => :mojave
    sha256 "3ac61cd27c3c40573c5bb1fa23dbdba5fec078d2db6d98ce3a43db6dd9f50f80" => :high_sierra
    sha256 "37ce72e5a5f1af96b3f72cda091ddca5612ff9e0049583319e696d518123adcc" => :sierra
    sha256 "a68ed7c9a690f7baa19e944644f88712731be10027b9526d535d507456628010" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Saved API key to", shell_output("#{bin}/cash --key foo")
  end
end
