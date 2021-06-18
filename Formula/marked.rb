require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.1.1.tgz"
  sha256 "8812a33e236a35f7d48829c3e3ccfa42c765beec67c07af42e7febe66ebeb09b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd03d4ede008a5bc92207314dfd824c60707cb98fb14c02b3b4a777074ff35be"
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
