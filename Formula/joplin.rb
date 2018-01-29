require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.91.tgz"
  sha256 "edf9a879f1ae94f043d14bd23622d5e91d567d93d3fcc00ed01ae66046ff87d9"

  bottle do
    sha256 "df0c3e8587a6193f00c0d836e20ac2d89ccba6ddd283194d2fc09a069c768b9c" => :high_sierra
    sha256 "14930c5a07b52b124146601add3949c204e60bfbf8e7a83e8d507dcc24c51d77" => :sierra
    sha256 "96b90497bfab4a84bfb815931389f15c4ef445f0467c34fa819b936c0e85ea13" => :el_capitan
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
