require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.10.tgz"
  sha256 "9767266fcf41b477a7f06c894c434dfb73c247faede282f81cf5ecf2366cab3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1669dba852aa89b60fb9b9bb987dc073f623ca4b015333f959da77593d5474d8"
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
