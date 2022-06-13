require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.17.tgz"
  sha256 "69b1e23e3619aabe5896f8ad4a4d0ccacfcbd4e44b0946db90598c3639a57ce0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b514a4d0c43633103865803bab753016528ee558cc8253f187fdfbcbc89ea4c"
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
