require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.12.tgz"
  sha256 "5acb10c4ef6c0e91cab9f1c9466dc8c6795c843f3bb646c35affac478e9c07e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d87acd3ed626b2a7d8663b798b406b1581238249a1871cb544a4d14a1928a5fd"
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
