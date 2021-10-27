require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.8.tgz"
  sha256 "36066f7a2be43b2479fe46636c67cd4e0f63cbb20f0383f3ac941f36889a66a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8a7afe418c192f97a24f5b6aca7e5955f33b8a4e769c09977870ef6eb57cf99"
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
