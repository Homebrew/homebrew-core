require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.90.tgz"
  sha256 "4723a2949ea0ffab31b17ba0c8a07c7383bc585510acaa4466e31a624ce46353"

  bottle do
    sha256 "31fa45aa6042d0fc569bb98619353bfaca9f97cb04198b9f50831cbcf52098a0" => :high_sierra
    sha256 "189c01af121592549a08450fa914aa8ca9c16a6de7f2eca9ede91112cc17407f" => :sierra
    sha256 "88c9d5b29a2abf86ea3636c55b1a49750cf8422be6c1d3a445b7e1ce16ffc794" => :el_capitan
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
