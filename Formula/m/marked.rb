class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.3.tgz"
  sha256 "8078c9cf29371a863f52ca5199b3682e070c0a6833b16981dfa68e53435d8fed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9cdfc54b55e3b5f1ba52f5ea0e1c66fc46a8f5aef132f5717747b015bdce241"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", shell_output("#{bin}/marked -s 'hello *world*'").strip
  end
end
