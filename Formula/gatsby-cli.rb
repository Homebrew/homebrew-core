require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.10.tgz"
  sha256 "6f391d70163221e4a908934d1243b66be14912728389c4405d512369a8606329"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1d52220a719944abf7dacbba90c67fe0241d606f68eccbac73f799a4f627e40" => :mojave
    sha256 "cd05135cfc9bd0c47e2c975da3e5ad759615e55b28c9376c88d81cc100eafcf4" => :high_sierra
    sha256 "4a1d8a472b0ceff9802010eed53593287dcf8cc069ece2e0c807e76c46bbb3da" => :sierra
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
