class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-15.0.6.tgz"
  sha256 "580238965025644e540030dc59b981e4561c5d6b357c75002c7ffccffc588dcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0705f5a9ad71aaf0890c741f293e84fbe9951f0a967989b19c7e8e14ee986ddc"
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
