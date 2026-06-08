class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.5.tgz"
  sha256 "7d0ea56f8c29c0e6dec5665e62ad8089136819ca7028612e52301c2ba279dac2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "568ead3416ffb1b2db6f8375a4e6d7b758ef62d125ae87431cbc57f5848720ca"
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
