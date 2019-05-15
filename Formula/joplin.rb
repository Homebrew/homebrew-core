require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.135.tgz"
  sha256 "fbe48538043bc04fd2b265f1448adc231e00e5e7d9da233397a8e1bbd4802398"

  bottle do
    sha256 "298124185fde16a020c302643c265f82cf513fb2626f5d449c33d3873e3d4c70" => :mojave
    sha256 "54a6ba3bb9cb3bd882c6aff9e805b9b3333e25ee63f72b6ee2787abc9ab73430" => :high_sierra
    sha256 "fe27cd4ce9b5682bfa661795dd7e3473a448bd488c1d188d793e71709cc772a7" => :sierra
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
