require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler. Built for speed."
  homepage "https://github.com/chjj/marked"
  url "https://github.com/chjj/marked/archive/v0.3.5.tar.gz"
  sha256 "4a9cb612dd9fa4a10f9c43e252626b568a5beead2e3fa02f7b0e4f71f8453adc"
  head "https://github.com/chjj/marked.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/marked"]
  end

  test do
    system bin/"marked", "-h"
  end
end
