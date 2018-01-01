require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.83.tgz"
  sha256 "7c64c7f13f4df2b2a20cd6a918dd8816a952d15b5b58af09f857b42617200530"

  bottle do
    sha256 "e67545231d56b5ddbfc1e69e27ff46066eab516f40ffc593bb96a597ef63fd86" => :high_sierra
    sha256 "6fca34b48741980f16e7189345a782c884e9b15fefff667bba4c2eca0d40a499" => :sierra
    sha256 "250a940dbbf84543126b01559a47f3c76177efa13d45e81e395ac247beb16a34" => :el_capitan
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
