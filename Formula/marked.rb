require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.1.0.tgz"
  sha256 "febda707750e32c829578ffa35626ec03c32f5b65a106f81c3799d14766790e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d7128f310ae7033b5195d5e6f3a81da70857a89e0b06343b32eff21bd3180c73"
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
