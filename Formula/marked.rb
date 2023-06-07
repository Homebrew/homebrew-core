require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.0.5.tgz"
  sha256 "5f37fd91ce205e265b3f2672cc95a0bbf3a17c0f342cd860df9f2d6436cde891"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a32559dfc9b7a4625a64031c93612731065595566086b445e4431bf51fbc7a0"
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
