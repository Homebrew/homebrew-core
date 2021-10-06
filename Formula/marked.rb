require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.6.tgz"
  sha256 "87f018cfafbaaa8cc66937e74e94d2c18bcb94142e73c3d0ab8381b73456c971"
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
