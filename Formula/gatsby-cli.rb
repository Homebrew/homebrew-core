require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.1.tgz"
  sha256 "9ed953e5195cfdcd7d7ce55c22dff2c10f02627abd95b7accdea8947dc40e824"

  bottle do
    cellar :any_skip_relocation
    sha256 "32b538f05ca6597f1ce4092c61507435618f71f766905b15d5897d0613c4e1eb" => :catalina
    sha256 "e8d3a2eaf69cfa92821b8aba5ca8bc925e4f468057fc07b5872a11c183f474a7" => :mojave
    sha256 "eb63be86abbf912545cfbf4e2a640f0ac28781688d265d656d935e202e771d86" => :high_sierra
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
