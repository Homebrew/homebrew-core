require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.8.tgz"
  sha256 "36066f7a2be43b2479fe46636c67cd4e0f63cbb20f0383f3ac941f36889a66a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0885d4ea75e9c6fb5b99cede540022185fbd23d2b5842b99f979de61d206f7e8"
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
