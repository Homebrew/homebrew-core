require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.44.tgz"
  sha256 "2438135afc349d447507c8807a51163fe70843455af93353c9543deb0d49cbf8"

  bottle do
    sha256 "761f1369c40c2e1820ef3558092b2b5acdcca003faa3132a7833433655cfa767" => :catalina
    sha256 "b7ebe0f9a2b9b0a57d3ab9d5d5c5ed9c9cebce5e743c9bea2b92d4b39cd01c19" => :mojave
    sha256 "c6b54ef3758cf945e8b3f6e15ff3011b67a8d1d76ceca7e63bf611dc8683efb5" => :high_sierra
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
