require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.30.tgz"
  sha256 "0fcc5ff04d28d01c3b9c508a48532406757961948148bb720f82d2129855ebb6"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb31617c9498219923312f8750b46a133d5da958ca1bc2d7fa2219ae516513f2" => :mojave
    sha256 "6d7afc1559dd247355d5c546175d7f28c83d39c1798a2e8cdae421c7a6d7ba86" => :high_sierra
    sha256 "39072a4ed2ba9cc646ed75615de4cd93f484cb91fc0850efb899f7a39209a518" => :sierra
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
