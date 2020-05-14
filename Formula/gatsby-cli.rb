require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.19.tgz"
  sha256 "e16539708c6596a2772d675e1446c8e6f2b058e97a0252b5c71b2260372f5b93"

  bottle do
    sha256 "c1fc48b8a6b13babd742e9986632e66502ccaf24c0318b2fbdb59a2f0162b174" => :catalina
    sha256 "6282d66688865ecebf48ca71fae98562b56720d43b253128eaf8336c436ba7b4" => :mojave
    sha256 "8e579cbfadb4886f148478a06d005606448b35a58f818cc6dd82a96e7c016366" => :high_sierra
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
