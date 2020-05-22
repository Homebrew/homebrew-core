require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.34.tgz"
  sha256 "26de449f0c608b59b8f001011c47a9e1516e8e0ad70dc915683ac992eeb18ee1"

  bottle do
    sha256 "7d1a4c12afc11caa620ae7827dad7e82ac5e95f1dde4ca9a98bdc6fe73559b2c" => :catalina
    sha256 "bf34bdcb8f34a36e44645c1adc4c5447ee5caa7ddff1b7c254ff550ceef7c3ac" => :mojave
    sha256 "39e5c98b3159f3d0f4715d29c8638596fad698ebd1a66558c99c4cc9c6c7893f" => :high_sierra
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
