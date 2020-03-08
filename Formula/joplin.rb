require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.161.tgz"
  sha256 "e5a277075d672fcb0a6d22e8de4794dc14f2602d460c35a51e69d0ff7ecbfac1"

  bottle do
    sha256 "22b09a00e23a0776739db7fca00c9e8fc186f27ca495705eb5a65f0156c94634" => :catalina
    sha256 "f97df4cd9e8168bc463638a2ceb65b961d97cffd576d0c2537d8cd23da2e53e7" => :mojave
    sha256 "43e6b54fa7cf6a0c75fed20730409cdb59cbf010a4a8ed5d792d8eba2fe29cbf" => :high_sierra
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
