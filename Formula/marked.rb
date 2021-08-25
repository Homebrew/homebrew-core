require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.2.tgz"
  sha256 "25d241753561b472915b4a233e0854b3ecf8d9202eab8a98d003afa1cb3537a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79f1e59fb2a582c01136a2fa72a08cb0d47b9b6061023e70627186f6b1550715"
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
