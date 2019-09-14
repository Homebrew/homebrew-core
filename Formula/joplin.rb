require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.146.tgz"
  sha256 "d7dd4572c07f2c843cc939e48d2ee0c91fef8cfb005448e6c1c9611ba443b48b"

  bottle do
    sha256 "3cba5766a2aa5a27a465dc87a92ac7c5d365ea9779dff08cfc65941b648cda2a" => :mojave
    sha256 "82c8cf70cfbcd713fb1610838daffc592d25e050273b551bf8fbf4dab155df32" => :high_sierra
    sha256 "9c56f91ffe62d6b2eb24427b9661e41b4a1fe97ece4a0a7388a0a527052bb496" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
