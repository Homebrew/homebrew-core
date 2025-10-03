class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-16.3.0.tgz"
  sha256 "c333c47cd3802a1d631dfdd8c6cfc411a88599a872c04ce8cd2291381a7767a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd20226f97d10d7424ef965c159e2ddf98f03c71e9cdc09ca139f2f8e3f7fac4"
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
