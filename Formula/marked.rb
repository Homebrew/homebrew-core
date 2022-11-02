require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.2.1.tgz"
  sha256 "ee21b7b1f4aae0fa57b67126b45879da2f653c744d7250868497296205a49815"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b3e9343bcf4c64ec6bd08620b705dab97b4407fae5e195ab430a846c9217f49d"
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
