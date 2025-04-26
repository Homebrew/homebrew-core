class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.11.tgz"
  sha256 "ceb989894e243b04249c188c42d45e18cdccf7eaa20e8bc227b2360b6555f3ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f460e335f5218ce50745434325c6ccc014bf7b8331e4ea1b44aff2e9dbb87c1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
