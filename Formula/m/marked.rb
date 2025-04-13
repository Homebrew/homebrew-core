class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.8.tgz"
  sha256 "854afbe46d875f64502a188dbbed8f939f42946b0cba8a0723af9175932285a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e203d21717e05dcba4ab2965010293ebb16dc560a96017038f274fbd8951eb6"
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
