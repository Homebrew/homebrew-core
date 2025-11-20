class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.1.tgz"
  sha256 "d09bc4067748b71af131a261550193cfefba014f67971f3890f2269293f5a60b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3fad2d5cdd0c08c31a0a20dcb4129bf956aa9f7601649a0e0a07dd9191e3041b"
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
