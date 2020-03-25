require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.2.tgz"
  sha256 "20d0937996fb419e00e4f90b9a9ac9c7b3022767be5b6ce0125c08baf9d1a70a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5b342a5194424d62ac5f0baaf523eae190b30393247a2c861c80e8fc6d59da1" => :catalina
    sha256 "688183236bf8eda318fe2f48c68b9147606a3c1df03ca8e3443352b6355337d5" => :mojave
    sha256 "28677bbf9226ba26a8c28807b2849ac6ba5fb27fd583f27af0d2fd51c0df2eb3" => :high_sierra
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
