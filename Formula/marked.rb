require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.2.3.tgz"
  sha256 "acc9fd7d355f35de519b38c14f1eae08a4abcce75a7e3df778c96cc758df5d96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69a44c7f3653a8731dde26275def89127b8db4fd9f2005643f77e5a154f0abc3"
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
