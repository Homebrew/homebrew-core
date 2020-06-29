require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.52.tgz"
  sha256 "fa55023087c9e5c2a906c981588333d44d53434218470b5201004f0113fb60cb"

  bottle do
    sha256 "a3ae8db8ed292298e11d7c4a04dcd81581ae48e304d7800d3c6185a0dff79258" => :catalina
    sha256 "e1591688f32abe0c837cd4962c102e07960262d37d0c513938030d20644cdfdc" => :mojave
    sha256 "42f48c98b4f1c40054c99081c877e536086ec1b6f4c6004856404e390ba2a08f" => :high_sierra
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
