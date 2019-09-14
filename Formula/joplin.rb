require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.146.tgz"
  sha256 "d7dd4572c07f2c843cc939e48d2ee0c91fef8cfb005448e6c1c9611ba443b48b"

  bottle do
    sha256 "0ac59071813496b98820e98afeb5a4b0019dce1f15e7dc82a1977ffb6fd0d295" => :mojave
    sha256 "c12aab2438ba0ecf1ece218e5e6c48a85672adad647f09ff001ed3156d42c8e4" => :high_sierra
    sha256 "14d92956e40173f5c3af35beb987e72ac376e0956ea57682a010ae16ac85f3eb" => :sierra
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
