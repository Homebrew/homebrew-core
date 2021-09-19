require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.4.tgz"
  sha256 "422984428c77cc28b10f2b64d3483edc8382ab835d17b12b9f9910a9faada90e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0a6e5db8571d251a4ea732baa90091f44c8f2cc4c6b687adb8563b0797d28a1b"
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
