require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.8.tgz"
  sha256 "b66ddda03b91a21032f06f9a5debcc073193c0a27f89f975d2aae9dd414f8035"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "069bd5677ddadf7dd47022cfd0b480bebe592f555cd0b1cf9b2e6125a98cdb92"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a944414c55f5f81ed736a7f45f7da1c7cc2f11318040d505f65a54381f9ace8"
    sha256 cellar: :any_skip_relocation, catalina:      "c31e509e5084c9b5073f538e14761cac993832af83d44b997774518ac0844ba2"
    sha256 cellar: :any_skip_relocation, mojave:        "1e3e5431582de7368a285c8281b68f2eb1360225bd84cd7e00aa6c53e2fb8101"
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
