require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-8.0.0.tgz"
  sha256 "e9ef5636b5ea7fd4c8d8b8b0a6ffce566224cd41c61e0c3f98c409b18a825c96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be463b588bd6182d8226a6172ea1310c0435374b6e26432956184856d85a9826"
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
