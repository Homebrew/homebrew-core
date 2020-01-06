require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.23.tgz"
  sha256 "bb6a0ad7b6c1cf0ce509b0a33c34f0940da7906be188abbf1a25f59377473581"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4ef25d280d56939686dcea8af6b90edaa1b95d68059c1dfbf6c4da262cc2b2c" => :catalina
    sha256 "63e206640c0690d999cce6816ff2068f27f81c40d67fa6192bb0f3a3133805f8" => :mojave
    sha256 "0ab54f1eeb0df7835c87f844c35f416225a0bbba5cfce50e88c0819b6e8a8dea" => :high_sierra
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
