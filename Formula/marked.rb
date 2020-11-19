require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.5.tgz"
  sha256 "5d6d53b779103a2b8d5d6227d386336984e44c7bd1302cc6b41f1d539878ab2b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "696c6e074dfad53cd54359a26115b7deb149a508f0c56a32ca8b23572d669bb2" => :big_sur
    sha256 "2d7d7d92f82712f012ec042b88a247e45777d2c712f30a1aeab696656b493d85" => :catalina
    sha256 "dedebec9f51f7dbe3f4fbd104c3991b62c362a286c81d5605a95cdcbe20e3076" => :mojave
    sha256 "7cadf28836fe33c3bff11de0e751788a359d8a6dea801650715d991acbd1f9ef" => :high_sierra
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
