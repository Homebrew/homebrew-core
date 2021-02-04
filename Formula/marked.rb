require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.9.tgz"
  sha256 "b17df81ae36ae3800c0e0eee7da7ede316203b0bc03d649473f5a94c5d4c42be"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4a944414c55f5f81ed736a7f45f7da1c7cc2f11318040d505f65a54381f9ace8" => :big_sur
    sha256 "069bd5677ddadf7dd47022cfd0b480bebe592f555cd0b1cf9b2e6125a98cdb92" => :arm64_big_sur
    sha256 "c31e509e5084c9b5073f538e14761cac993832af83d44b997774518ac0844ba2" => :catalina
    sha256 "1e3e5431582de7368a285c8281b68f2eb1360225bd84cd7e00aa6c53e2fb8101" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
