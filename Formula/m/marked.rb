class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.3.0.tgz"
  sha256 "ac4b23ef5425d83f7aad00a81640d29e5b0fd81a6361a30fa96b4b8bb228ad24"
  license "MIT"

  bottle do
    manifest_sha256 "3915165faf90b0bccfcd221e0e348b86961b85170ea1c8cf77a4e1bb2f79f8a8"
    sha256 cellar: :any_skip_relocation, all: "35c2753a84749f71f7b470c08a9f725029c22dfd12b63da01b0dbdc86a85b8da"
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
