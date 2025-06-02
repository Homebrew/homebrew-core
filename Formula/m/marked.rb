class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.12.tgz"
  sha256 "39a847a896af15b2846f927da55d444619ea55a55c236e10333056474b793aaa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "86b56a540df11b8f2fdbd283a2971aaecd7ee489766e1b9b03856ec8f3772707"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
