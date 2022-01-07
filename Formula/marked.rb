require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.9.tgz"
  sha256 "619ec1485c6712b1411dc6a3008ae3345ddaba53b56d34f6b16181fce0b90516"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2dcb5d91b25e3dd83d2136ecfa19013fd7052617b53245508c1a869bd34b8164"
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
