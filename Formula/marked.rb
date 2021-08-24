require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.1.tgz"
  sha256 "ecbaca28b2a1e9356abded869a16e519cb6e1a7fea4dadd3a1cda5b5a680b3c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61b34f22d106cba37277e74ed4d894d8266acb65d7a660d2a5bd8b1c861cab76"
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
