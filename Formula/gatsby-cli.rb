require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.28.tgz"
  sha256 "5dbea1c9d6f9906e7ae9bb087dcb9cb16fa4895aef6c084c8f80801f1ba628ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "163d6ca748050c6d46ca419b0cb3a31668168a5cbf0d584c14ef9ea0ebd9e6ed" => :catalina
    sha256 "9cb68a86826b61d5deed0311842ac602e57367eff80ffa9b5f7902535d5cca24" => :mojave
    sha256 "d5efc43086ecd9f94f43b59b8dc5b0208e566cc07ad3f4edf2c436cb4033862e" => :high_sierra
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
