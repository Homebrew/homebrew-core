require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.14.tgz"
  sha256 "f569da924b52079c64b754d4756e207efbf5701f4e8d2b00ea5f123e31f0f1a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1d6ff1f3d6f6a3064f28f3d08bc8399574b367d794936a7d304c9c3aff167da" => :mojave
    sha256 "e91d3825713bb331cec23fbcbf4c592988ea2c43541db18854e1430886f49add" => :high_sierra
    sha256 "9ce5063c9a1440bc25cdddfd28989b4bd00c49d7b15e9db8ecb42d371b27722a" => :sierra
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
