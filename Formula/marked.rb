require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.13.tgz"
  sha256 "d510226faf84403d9edba3912c44ddc18fccc3b31c8cfc2c4565cf12233bb489"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "978718f53b09781869c7e2309457050c3dbe95bf73c66b874f80bc62a4b0c9cd"
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
