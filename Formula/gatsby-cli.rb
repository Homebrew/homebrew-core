require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.58.tgz"
  sha256 "90f6aa7b4f7a6b1633bc22302b26be2c08672ab0cfdf6e43f7ec07a69bb9375e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7db058f92a8bcc6457cf42b36ba66f61769a75b2dc7ef6955aafae8b76656d2" => :catalina
    sha256 "13a8fd9ef5deffb279417a91ede44b0e8cf446149a2f16157d980f300ae7eee9" => :mojave
    sha256 "1be90f50d8adedce5e1f6f78c2c2ad1c245b1c9ed086b42432283ab595283685" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
