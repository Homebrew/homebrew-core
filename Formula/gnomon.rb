require "language/node"

class Gnomon < Formula
  desc "Utility to prepend timestamp information to another command's stdout"
  homepage "https://github.com/paypal/gnomon"
  url "https://github.com/paypal/gnomon/archive/v1.5.0.tar.gz"
  sha256 "5c9d83c33a1b364f0b2ad710416f97efd701b4f7a4bce800065a6b154772a695"
  head "https://github.com/paypal/gnomon.git"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gnomon", "version"
  end
end
