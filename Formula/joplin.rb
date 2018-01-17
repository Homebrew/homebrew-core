require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.88.tgz"
  sha256 "744aad467d1f1fe9da3509839c7ef694a585c197fafa7ee5c0aa53f7712abc52"

  bottle do
    sha256 "07da0615085c22be9dc3fbdd09fa06f8ab4d631c35b87624a95fda285ae1602b" => :high_sierra
    sha256 "da292da3f73a67e4c938ccd5a4123fd045557091ee065babb112a5148cec393b" => :sierra
    sha256 "31ffca84d348251aee2868ad6a932bae68e89b4badfe0dcacffed1dea8602fc1" => :el_capitan
  end

  depends_on "node"
  depends_on "python" => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
