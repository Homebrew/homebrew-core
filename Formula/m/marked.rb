class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-14.1.3.tgz"
  sha256 "6d6588a5e69c3fa1819b3e2faa3e806cc6ffe7d3329d1105ad129fce0e31bd74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30a4eee412e3a26ffa373c91208f5333589dc1416863193b785794905aefaba3"
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
