require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.3.0.tgz"
  sha256 "bc795399d6e7c096521080d66ce6ca96a00875b4bb0df36e0f041815484f633b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62e470eb04dab04a18802e3c8fb23e0689ee6594c8a437199f824ec7f8d8bc16"
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
