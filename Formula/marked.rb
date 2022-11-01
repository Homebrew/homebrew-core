require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.2.0.tgz"
  sha256 "0dc7a80d4cbef0fbb063237060fed65a915595b2e8b97ed56ea0e231b2e88062"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af140d4a5a70ba09a2bffec81297b329fb9f00916e5222a3c7e445fd431883bb"
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
