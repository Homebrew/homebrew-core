require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.7.tgz"
  sha256 "590679c0053b5fff1cf714b47abbf6fb712e916ee6a3a0c1210840551716ac18"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "739a746cb470f65d9f448c4dfc9c1d6b49de180c283e2095f356c54256083d02" => :big_sur
    sha256 "faefa20e213980936e1238dc1f46ffa4a6ce2559c9802c554a1e4f22dd388b9b" => :catalina
    sha256 "8181b402523e398951b90018efb048d314b3b62cf2671bae8e319d0f10ff9a3e" => :mojave
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
