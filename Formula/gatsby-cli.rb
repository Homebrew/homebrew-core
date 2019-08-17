require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.31.tgz"
  sha256 "31ef667d2c4c6def5dd16ffaff77a8254379830a0f92b5da99280cfcd1b73b7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "89758911486eae35cedeebfdf8c20671ab985f36bdf33088e3c8a1b47e11cb5d" => :mojave
    sha256 "d1ca4951fd69bd595b804f7fb76235be39dd629e96160f4b86da0394209695b9" => :high_sierra
    sha256 "12f69b604ab49b65953708f96153846b461b38da70bb141c050e9badaf1a7025" => :sierra
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
