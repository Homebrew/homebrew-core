require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.1.5.tgz"
  sha256 "e6fc88009c49766b4afc5058c10ef3f8a5d5f74940365c3c124bda2aa4db14bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "196e3e689bd6d1829f2a7fdf57c0211786958d32ef3b29c107290a429fbbf44f"
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
