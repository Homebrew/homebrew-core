class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.2.1.tgz"
  sha256 "d66c5213fc203466186060105b01f51896764ba64b3797d2620d02e28e34b8ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d16400b24a542b218191a9b3ab5c81eab5c2b9927fc5872efa9f3f5bfa807aab"
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
