require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.8.tgz"
  sha256 "c8f4cfab4d958f9d2e318ee6d5e4b2441adaeab77cd332b1861d1cc2becfd310"

  bottle do
    cellar :any_skip_relocation
    sha256 "74d252cb82555f06f3bd38bc6cf3e6f729e539d53c85bd490df8474816809417" => :catalina
    sha256 "94d626f183b393417a02c8c8e88a294d5ac9722eae9bb3cef1e19fe9697e4a00" => :mojave
    sha256 "266487c53a7bfbddd325224adc10c45180e0967f6dded3886c8804ab55fac4dd" => :high_sierra
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
