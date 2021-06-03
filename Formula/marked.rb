require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.0.7.tgz"
  sha256 "d9793800df8d6a2b719af7d5ebbd6782eb89d7d05afe5a589a584d254f6a49af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d7128f310ae7033b5195d5e6f3a81da70857a89e0b06343b32eff21bd3180c73"
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
