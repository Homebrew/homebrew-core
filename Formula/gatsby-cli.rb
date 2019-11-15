require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.11.tgz"
  sha256 "214e72bab275bc272d86c3b64632872e10170a2369a1e58c7b116ae26e0d0de1"

  bottle do
    cellar :any_skip_relocation
    sha256 "fadc66ee3c998db46d8566456163a73387e943f31c8ab0a9d330c2d2ee361a8b" => :catalina
    sha256 "062cbc85df95c6a4a59239b616149a0e506a19052b077d0206235f9d356bb33e" => :mojave
    sha256 "c4636c75a9967d564e0b11e80945477ae3dc4e3c41a2fcac32b2cebeaeb1de7d" => :high_sierra
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
