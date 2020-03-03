require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.0.tgz"
  sha256 "43e085fa7062b6c417a72f904b45c08c8850d9f3be450ed4a39ed38c28d23bdb"

  bottle do
    cellar :any_skip_relocation
    sha256 "468f69851cc2ea92339312677c2660c3fae542c3c235348092308c87b1180716" => :catalina
    sha256 "714f67ac416740c6c13632e0d01eaa9a07fc7a8ee1b6265f30c7fddb7b07935c" => :mojave
    sha256 "58b3e031902cca7fe966c6e0687bcf2ed2cb7cc5d3d99a4237246b4a51b55740" => :high_sierra
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
