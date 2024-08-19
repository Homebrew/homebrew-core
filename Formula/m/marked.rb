class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-14.0.0.tgz"
  sha256 "a37f8a84828ab422b236bfdc73db4f4349d02a003d38f3d94a71ede92093939d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e395d4852c379aa7a98c796bbb1bef21423e3cf012e11b498e40c9be4e4d65fe"
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
