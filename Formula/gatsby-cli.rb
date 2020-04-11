require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.7.tgz"
  sha256 "80ad7f8be6a8c013ed78b1415ffdfe040511c19e6ee09cf9a2fe18d04273c930"

  bottle do
    cellar :any_skip_relocation
    sha256 "caa1a238c5d9460a0d8f1b9840f616959020e9c61eeebf4518b544b7eab082c0" => :catalina
    sha256 "342f741d6e441fa7d9bf0d5c1eb9300e397449153ee8f92b2272f161c4ff92eb" => :mojave
    sha256 "a2fb4118b3c79751842ac860640804eb26c216fb22e512ac38bf71c889e93f65" => :high_sierra
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
