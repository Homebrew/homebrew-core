require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.0.tgz"
  sha256 "224c119ba61e79bb17dd64277adc4bd20070a5d0bc051a2f33d63025f4fd4e00"
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
