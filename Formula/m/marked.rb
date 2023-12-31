require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-11.1.1.tgz"
  sha256 "c29dddef7eed40d237bdc6e7886985cb196b234f6c936c2eaf5d6cd2bc1539b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff0dd9d8bf4cc178929d601b5dcab3814cb0021b6f700ee2a9d86ae9ba0e2807"
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
