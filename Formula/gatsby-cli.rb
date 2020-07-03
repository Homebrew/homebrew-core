require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.56.tgz"
  sha256 "cc8658c75108fd1ed1aaeae928b7bc61ea854d4c2d77ec501bc2c44981800336"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a264a549f3f9828b7b8a22b8fccd6873b6452da5998cefbaeeaae1dc3749939" => :catalina
    sha256 "f2eceba9ad6b2146714fabb08e27c3cb586e9f9b397bc671347162706bcc1034" => :mojave
    sha256 "10a8ccb1fd09f5c6a5dd3a68f6146d32a3d30bfd2d1c957fbab868823aed0878" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
