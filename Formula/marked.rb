require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.1.2.tgz"
  sha256 "b0a58b4a7a022a3e9d96e2dcca22b60a2f381978282784cd6986e8b0883860b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd03d4ede008a5bc92207314dfd824c60707cb98fb14c02b3b4a777074ff35be"
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
