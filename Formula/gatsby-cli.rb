require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.20.tgz"
  sha256 "d5a81e554857781b59abe40ba2f30e88693a79923cee8a9dc97a9a353c5026a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2425d3350b95151192a1411b1117d22d87eaff3fac4db18afab5b5a01db5fb2" => :mojave
    sha256 "c5d39969b54c5acbbe41c5203eea2cadaf8ab17f4f691edde97ebfaae3688e41" => :high_sierra
    sha256 "0431495ab1e69da11046d85b650090da42c9aa392840602d89f094bf342f3b3f" => :sierra
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
