require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.36.tgz"
  sha256 "4113ebd63a69f5519dbff536eae9ec5173d6f8ec93f2ce17886b2c7307caf9ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "3dc54333520c687cddbf02c1517a0b64e171bcf0a86b07108e57567cb0a7869f" => :catalina
    sha256 "ab6be8db89294566fbc6aab7039f02bc86d49454ea72c0f17976c9e0d93b5db2" => :mojave
    sha256 "ec3618903b2c497b1702bd59918c580827a301057bc071270659185a720397c9" => :high_sierra
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
