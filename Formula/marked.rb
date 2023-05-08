require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.0.1.tgz"
  sha256 "37c502f594101c1634942efe47f522c1d4081b69003a7ec304d4e288e7b916b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e852739d8d72c06070ebf3c7657f28bee35b979da069fc93689a512731af1602"
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
