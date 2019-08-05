require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.27.tgz"
  sha256 "66a42202b24532b017a7605c1c1cb62472e312daff96f63c3cc05c93953bce68"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d14d19d18d2be41f9cd736ec965617931ae2b31dbaf8b05c0f447caba65443d" => :mojave
    sha256 "1f6a21028a768b35a4b07ad8f5ea0ba7b01a10a56bde5486b16c2686bcfdadcd" => :high_sierra
    sha256 "99d9d297b767a15b408ce3a17257749261f1ef647007ae5bcb53ddc4b3c26dec" => :sierra
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
