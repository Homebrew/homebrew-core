require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.0.3.tgz"
  sha256 "1598cfb66d438120aa93e7e1cb83454e4855297217c622ac99a7c6d04ca14ddb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ac264e413d3e006ea3d92bd41926d0b44faa328188fb057b881a52d55f501f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa6d2d29bae0c1ea4d48c2be7b7ecbf71e956f0a12a714ac825198fbd79a3a4c"
    sha256 cellar: :any_skip_relocation, catalina:      "864b32fcbed0c8f4553d80ed263cb03901d6783fd273e53081b201c49685537a"
    sha256 cellar: :any_skip_relocation, mojave:        "24636afa19f402cfecf6a64f038bd0a92ca7abed7be798ca4cefae2fc90fb5ea"
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
