require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.3.0.tgz"
  sha256 "bc795399d6e7c096521080d66ce6ca96a00875b4bb0df36e0f041815484f633b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1d57bd33e3a370c31df4eb78bd5c5a9f8dc88fdfc0220f023ab3db0ae420c4d"
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
