class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.1.3.tgz"
  sha256 "5ca94887c584f7a67b27acd6b08e0a19da651418b627295d82d57fe63a56c82b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "386236f8d4f33effa14f0270155143bde747e999dbed34d2d0e0d78906d71a75"
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
