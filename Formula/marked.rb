require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.7.tgz"
  sha256 "dcac2dfe58343e7cb24ea1bf3115eec329e8d694011858a06edfa9bcde8d4713"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0885d4ea75e9c6fb5b99cede540022185fbd23d2b5842b99f979de61d206f7e8"
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
