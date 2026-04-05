class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.6.tgz"
  sha256 "d0ca499e365edfbdb6df8f769417bd7e9308d142f5e86e6ffe76918db6a399db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "96aefc66b91e07fb29af634c1586cd7b7d086ef8b8064f3d45950cc30c65d90a"
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
