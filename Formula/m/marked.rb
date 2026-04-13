class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.0.tgz"
  sha256 "9a4feb7d1643a6dca3ca62fab9c883d18d2838c1c717a000088d7a991fa3cc41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "39aadd24970afbb2eefee345ec4dc934c91297b4c72770d4d7da588d6e553ac5"
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
