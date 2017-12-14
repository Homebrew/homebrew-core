require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.83.tgz"
  sha256 "7c64c7f13f4df2b2a20cd6a918dd8816a952d15b5b58af09f857b42617200530"

  bottle do
    sha256 "73d5f3dd7ccfa7071c9b013158f968a0f8d4de360b8126fe15a163d8abb69c0b" => :high_sierra
    sha256 "0bb5d6603026c41869489b93c5e3c21792d96d6b576c1d161b3463576576e7ed" => :sierra
    sha256 "f171fbd3734d094512f4f69208db8c24fd4742ce7d9a4a1cc75c2e0088941b98" => :el_capitan
  end

  depends_on "node"
  depends_on :python => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
