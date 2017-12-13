require "language/node"

class Passcards < Formula
  desc "Language for application scale JavaScript development"
  homepage "http://robertknight.github.io/passcards/"
  url "https://registry.npmjs.org/passcards/-/passcards-0.7.1115.tgz"
  sha256 "b80f662146b0693655b20e155a72d8b24a3f62dc2e301ec2416403e9690fd2bb"
  head "https://github.com/robertknight/passcards.git"

  depends_on "typescript"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"passcards", "-h"
  end
end
