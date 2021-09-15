require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.4.tgz"
  sha256 "422984428c77cc28b10f2b64d3483edc8382ab835d17b12b9f9910a9faada90e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e73b3c547be314e68dd1ad38fbe3156ef8ec8c55abec05462f6aea6d0728c093"
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
