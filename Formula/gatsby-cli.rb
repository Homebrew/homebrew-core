require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.27.tgz"
  sha256 "bc413ceabb78ff54faba810cfe83c8640af3bf8ec879e0f92d5ea3fd18f2d613"

  bottle do
    cellar :any_skip_relocation
    sha256 "56b15bfc745392cf7aeffd527011a885940a360dec17fb1c94875ef54f2be76a" => :catalina
    sha256 "dbb2bc9322f1e668794bd62b34f30780f73de63ea436d947d3a05617e556740d" => :mojave
    sha256 "18dc3c001939470a3d3d173bd53e9457654f6bf697307175e627011978335b67" => :high_sierra
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
