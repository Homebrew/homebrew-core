require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.44.tgz"
  sha256 "2438135afc349d447507c8807a51163fe70843455af93353c9543deb0d49cbf8"

  bottle do
    sha256 "a77fc9a29a20276358028b382fcbe7443b9360e9be8678df922ad58aae5ccee9" => :catalina
    sha256 "3c0e3d850ae669dc712535fa6fce25f7409f7e7bdd9477fb381339a794016404" => :mojave
    sha256 "6eae7253d501e57805a69c2d97a1a2d0fb674e68d56242b5b562047a10956c23" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
