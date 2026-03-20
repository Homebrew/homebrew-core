class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.4.tgz"
  sha256 "651ab10bab456da22585aca676075c9cefcfd8e65aca64a94a33d5bdd3054ce9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c7267bd7d28ed7733aaeec66f07a1aeb5b80d4ca17214c6c7be412f4691cfce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
