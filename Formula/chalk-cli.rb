require "language/node"

class ChalkCli < Formula
  desc "Terminal string styling done right"
  homepage "https://github.com/chalk/chalk-cli"
  url "https://registry.npmjs.org/chalk-cli/-/chalk-cli-5.0.0.tgz"
  sha256 "0c0a4e8d93b923b23fea33cee5ebb6b3c9029d1adfac5d932b5c1c428e5c0782"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "092f65c0a922bfb51cf21d1b3be5dfaddefb61338b06a8c71acb0bc6c15310c2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "hello, world!", pipe_output("#{bin}/chalk bold cyan --stdin", "hello, world!")
  end
end
