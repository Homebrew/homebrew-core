require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-12.0.2.tgz"
  sha256 "6cfd2d09c6bce2541558a1547e5f3b9895ed743f0d287536ff2280e318e8a074"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "717d409f830e2f01f5f209cd4273064d102e3e9ae919edd098c9bd82f81c1b49"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
