require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.5.tgz"
  sha256 "5d6d53b779103a2b8d5d6227d386336984e44c7bd1302cc6b41f1d539878ab2b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "80faf549f7c3ef1032e3c42c471321f0f3d9285e638e9eb653962fd6673661e2" => :big_sur
    sha256 "25d3044a6032363b4c3bc7cc0f6512147fd431d864e03496b2d36a56b863ec9c" => :catalina
    sha256 "94c9671358e79834678d7dd4a4bc86e1c46afc7b0a6ef849f911249a2b46bfaf" => :mojave
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
