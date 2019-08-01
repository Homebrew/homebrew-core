require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.24.tgz"
  sha256 "4eee3cb7d873f8357adfc22683b0710bfdbce04219132f92e9d13f84c781100f"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf12b13de67116e3f957015e02038fcfefee26207fbe70ab247ee87df21d8d07" => :mojave
    sha256 "fb4c368ad386d822cba740ba18242ec5290f4098df838eed00de5f53c7a41fb7" => :high_sierra
    sha256 "ab5fe08ade26cb9705a54253ef7e7776d60d592688465e8315a3dae75fb90807" => :sierra
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
