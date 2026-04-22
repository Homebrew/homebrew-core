class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.2.tgz"
  sha256 "5e3fa42adc22af98ceb7cc24e53ec48ec70e020e460541d98321ec2a8435fcc9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7904bdb6f73105710ecedf32942a289ce99d0fd192947e7330d3d92bd48e4523"
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
