require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.21.tgz"
  sha256 "a909d5371cfb8688a0644d47048c1add0b497e25d4be928114f24f3d1b25f8b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "7179314abd5acad8ad1028fd8043a1597a8a9e5f7fa2d89e1b89ebe44c858fb2" => :catalina
    sha256 "f04132fe7cc856cb300534e15b2e14bb910aebba67de9de56df00418b27ba872" => :mojave
    sha256 "df9df45717dae4aa1389df47a7c140b1290dcf31e18090a08d3797ad016f5758" => :high_sierra
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
