require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.28.tgz"
  sha256 "fcd4309606ee140d3a2024f08e863e6376a5325830a650dcf1d3bf6ac831356c"

  bottle do
    sha256 "5c7f3c7e0021bf35e752dbf0fce2d5c29d59e5aa95308708562a70e1e7b18c4f" => :catalina
    sha256 "85ce78bb9a4e58c88c894550be5a9e2791c2e7b88495abfe075d5cd4eb413900" => :mojave
    sha256 "1319340163015c4e88f226ad8201c4c738477d8ac96feea58d5095b630a48936" => :high_sierra
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
