require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.58.tgz"
  sha256 "90f6aa7b4f7a6b1633bc22302b26be2c08672ab0cfdf6e43f7ec07a69bb9375e"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b7ea744bfd61c416582e4dc92f3943c0bb8e35ca8995fa3f0b89d67f8d5e9e2" => :mojave
    sha256 "119a8cf11c74dd0f0fb77e61923a4942cc05db22fdb18af6576e984000efeb7d" => :high_sierra
    sha256 "a5b10e591502765911891092169e7128d8635034f8f774dd92d90d4bcdae79e4" => :sierra
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
