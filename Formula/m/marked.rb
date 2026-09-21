class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.13.tgz"
  sha256 "a0a6d4ab6386b2babc02419c258512199a451150ed5f1bed47795d2b07f2d074"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1688512ed2ed61e304250cc0bf26770904140328587122667eeffdcc2d0ea788"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", shell_output("#{bin}/marked -s 'hello *world*'").strip
  end
end
