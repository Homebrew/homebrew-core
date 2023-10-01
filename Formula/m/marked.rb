require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-9.0.3.tgz"
  sha256 "455b78959f1ba0a77ad8501ed0f24ef31f235fa625ce670cb53db925973c444c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1df344086cb536cc0f87c32355431e88c6c2323ced6e2fa2b388ae4012b83eeb"
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
