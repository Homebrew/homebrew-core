require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.161.tgz"
  sha256 "e5a277075d672fcb0a6d22e8de4794dc14f2602d460c35a51e69d0ff7ecbfac1"
  revision 1

  bottle do
    sha256 "c0c365534133c7f48e9e015a9279e7f719331f62a07e2bcadb284934092d30a5" => :catalina
    sha256 "d1147155436388f512ffe2df2408a3183f4d46f7f520492521a3f4c415cab5db" => :mojave
    sha256 "956a5a259965459dd343bb9cc9f85a9c221b4f337216f399030386bc130ab463" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec),
                             "--sqlite=#{Formula["sqlite"].opt_prefix}"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
