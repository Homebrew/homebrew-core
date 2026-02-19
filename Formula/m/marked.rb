class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.3.tgz"
  sha256 "9cc71529c2d8e01d1843c81838d5b74b704c050169a0e4dc01affa9e53899c8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa238ccf16c74ee580c9e01ea4517cebcd840f7436bf7a6641e2c80aa9184294"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
