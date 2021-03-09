require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.0.1.tgz"
  sha256 "a7c2d3b13267ba811ff157441cfe1b7fcf5ebf268c2862ead4985eb697209804"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "722f50a4da81765a90ffb0ffa92bff6ca94ba570480d7a9f45f498a18e013ab5"
    sha256 cellar: :any_skip_relocation, big_sur:       "39f9f1f360a49f502d39196627cb76b570981645cacc3858a4edb5387146f23b"
    sha256 cellar: :any_skip_relocation, catalina:      "364cbf030af81bace489c131dedfca66edd7a530f531b19ed847826d2610c461"
    sha256 cellar: :any_skip_relocation, mojave:        "2fb7473810118285da26992ce1de87e4c9d7897e8fa77089201b90a3e1d70c0d"
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
