require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.100.tgz"
  sha256 "29a0429bfd4ec5f2be42571330f0bb112ef2511a8931a063fe9af0b9b6c76562"

  bottle do
    sha256 "da9f2d859583c77abc4efd54ecc94f857c263523f8c5b22d796000065287e8f0" => :high_sierra
    sha256 "77183457918b4e4b537356460667edb105ee9f1b941238818efc35d06a373b7a" => :sierra
    sha256 "104938c3fcea4860f148bb8fed43a9b5114323a7b2f11e5952a897bd0925b2a9" => :el_capitan
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
