require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.1.1.tgz"
  sha256 "edaff292486eb4744e94121302da2d01f640e6c9997e55d22dab91bcf589b964"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9fc883aa8cc83755d24796a875ebb7e8a87d629867b528963519985a6226e283"
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
