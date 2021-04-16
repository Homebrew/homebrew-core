require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.0.3.tgz"
  sha256 "1598cfb66d438120aa93e7e1cb83454e4855297217c622ac99a7c6d04ca14ddb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf1dda034e4f93b2818575fc1e5c3af4e2a2643d2d63b9702d86343154e1c4fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "29dfc7c7de888f9e4d1e3fb93ade6a23ce2f6eb7ebfffd25c05714169d7bc3cb"
    sha256 cellar: :any_skip_relocation, catalina:      "1d2521bb85d8a0a4daf1fa07fcc69cecdf451a3f188fd8c62df80896eb244c84"
    sha256 cellar: :any_skip_relocation, mojave:        "21fff74f595b269276a6cee410688e36b746f1df50622d9965749abf251c6361"
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
