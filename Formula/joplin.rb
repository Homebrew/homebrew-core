require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.95.tgz"
  sha256 "947b70fde2167439bf08e54eac46ae90721405eb0c27a10c5241f858b924a0e6"

  bottle do
    sha256 "29c860d997ac5285ce3de9afb30b657540c4a603146365c08f33bbacdfe9cf22" => :high_sierra
    sha256 "769bc1b5f950084a32289b73ec038684fd3c8bf6f5407748d6092f47b98cb8d2" => :sierra
    sha256 "b47b108700a6897e1852484d1e59dc3fe09e2ebd7ee81f0037858f54fa43b05c" => :el_capitan
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
