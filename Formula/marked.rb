require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.2.4.tgz"
  sha256 "2762e8489f3d25469ec863432870a523a474afddced410e028411b5ea585a705"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2318c765d139b8e42973834605ece3ea3af92ab9ce0fb9b14645f0e467209a6d"
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
