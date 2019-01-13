require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.120.tgz"
  sha256 "80a96934f099ef45a35389184de718d683aabdd9b3371c179c0ae6fee5db9ab2"

  bottle do
    sha256 "d9b4ce17add87eab53f2068a9dbad86cd502f30860b4212d59b2c348e99fd861" => :mojave
    sha256 "f5d6b2f57e89f0e824f1f620bf91c437f9e5a181e5419d6164ba9cf17c463044" => :high_sierra
    sha256 "45ce024877e21d40651b76b1f758b2cd0ba645e7e538fee0b6207f92cff87004" => :sierra
  end

  depends_on "python@2" => :build
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
