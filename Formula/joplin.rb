require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.98.tgz"
  sha256 "48b0ea164ec999620735dd910153ca997c0b00917526c69209b2ed3735610845"

  bottle do
    sha256 "1d0a077c998977dca7ab8c98e765154436f6957db54f3225463b4627b5a4199b" => :high_sierra
    sha256 "589fdb83b5ce2f43842a23d179759eb9bf76b29c9611b93760d3b170bb3cf756" => :sierra
    sha256 "4211dd3d1a78aec452b81be1982829b274665b2b9371ce8ed5fcce30fab39222" => :el_capitan
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
