require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.13.tgz"
  sha256 "d510226faf84403d9edba3912c44ddc18fccc3b31c8cfc2c4565cf12233bb489"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c492d376dafa7f767f73fcf3f6a447b162b11a3c50a96feeb465ac9b4e33384f"
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
