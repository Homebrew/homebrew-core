require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.1.0.tgz"
  sha256 "7d2f4fb1e35d22de8aa1aed938fd787bee4b8b8cbd34716bcb087dec612104cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75d3a30d7ca5127e8cf3333175fc322e1f1d8901eb5241e257515373f150b198"
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
