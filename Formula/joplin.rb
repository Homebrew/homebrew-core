require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.104.tgz"
  sha256 "7217367c61ff3626b68f76a1d46ec7a3c1d5d174668b67110cd45e47d52838fd"

  bottle do
    sha256 "f9cec705db2be23f151de79a0cb6aa38e782686698e91e547a811b2ac81afcac" => :high_sierra
    sha256 "d9a49e9e3d0497a0488f57eee8f4a70de7bc1d0c47eabf3a16321df7f3a42ad5" => :sierra
    sha256 "8969b7e747118cf98343dae3864b6877f0890071435251e26d6b049d7fd4ee31" => :el_capitan
  end

  depends_on "node"
  depends_on "python@2" => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
