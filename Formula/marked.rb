require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.2.1.tgz"
  sha256 "ee21b7b1f4aae0fa57b67126b45879da2f653c744d7250868497296205a49815"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af140d4a5a70ba09a2bffec81297b329fb9f00916e5222a3c7e445fd431883bb"
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
