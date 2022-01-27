require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.0.11.tgz"
  sha256 "3f6a4e3e3031908d448e28924c11506ed469314280e041a5f24bf336f2b95e78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17189bdc7b813b28404857feafd2c64ad7572d2c6eff7344970f92e79107c207"
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
