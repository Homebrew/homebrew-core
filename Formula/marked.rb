require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.1.0.tgz"
  sha256 "2e61fe27531e81c26a3383b6d7473ebbc6ba6fa7369ce4f895533f5719e0873e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9798ace4c5169f9bb735d943f0f679f750117a400d8b76235be89340e4bb059"
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
