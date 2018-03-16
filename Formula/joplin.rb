require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.101.tgz"
  sha256 "6b9d83f3b0812385168c1a9a444f98c1a34cfe95e7425ab9b6a7bc117ed8c48c"

  bottle do
    sha256 "5a74bd3996fe0c24c43c8b9911e6062fadf0b667d9ed0a1ae2c14455b3c202b5" => :high_sierra
    sha256 "780337f278eba61e02890c5a6de2772a23f8953e1928472d3173a67d8f1f5388" => :sierra
    sha256 "16f284273bc43e13e2f8eb1acd47fe0e6b6676cfef3a5bb4e67bab2bf065f4be" => :el_capitan
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
