require "language/node"

class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-0.1.5.tgz"
  sha256 "133dcb72876b20a964f4a757ee647868bff1c34327e06e01c6cb80c8c18ff65c"
  head "https://github.com/aksakalli/gtop.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "false"
  end
end
