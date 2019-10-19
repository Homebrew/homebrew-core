require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.3.tgz"
  sha256 "83939cd4ea9a6b9671282fc89726224f67cb804f0393162133a7fcf1efd84e34"

  bottle do
    cellar :any_skip_relocation
    sha256 "633aada9c2b48dd3114fa353405ae94aa0d4dcee0c738fa3ebc784d5d0b614a0" => :catalina
    sha256 "c0f3bd8ef4e0dd42c28e7be86e98254f078a2573048217038feac616251ebf7d" => :mojave
    sha256 "3475fadb3255c00d729e59280a07f5e11661d926823a1f9640b64cecffa9f84b" => :high_sierra
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
