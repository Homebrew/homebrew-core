require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.116.tgz"
  sha256 "ddb4cd6246c5396064506cc23ab5773ec6d8c6075bba3ff338f68797ea2665e6"

  bottle do
    sha256 "ced478c8bfc3448980df08256530c020ce75f7e3a58ffbc49555b61fc7c675f6" => :mojave
    sha256 "9ef67f4176954fc644146501a2722c0aba562b75a7160c2f43c917f9c0d78df3" => :high_sierra
    sha256 "18babdfab5595fedb4019a38752834fbac8f510deba887eb2c23f674542f5879" => :sierra
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
