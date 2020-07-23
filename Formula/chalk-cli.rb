require "language/node"

class ChalkCli < Formula
  desc "Terminal string styling done right"
  homepage "https://github.com/chalk/chalk-cli"
  url "https://registry.npmjs.org/chalk-cli/-/chalk-cli-4.1.0.tgz"
  sha256 "000d9fa6969d5da248fc3b415c48e76a999e2f3e04594f14c335baab058c7a7c"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "hello, world!", pipe_output("#{bin}/chalk bold cyan", "hello, world!")
  end
end
