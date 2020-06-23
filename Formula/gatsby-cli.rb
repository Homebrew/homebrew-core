require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.50.tgz"
  sha256 "716491f0fbd8448032bdf6cbabf77408d4f22d413ce81022065088bedd9c55b9"

  bottle do
    sha256 "2652e2bd5ed70122a1d091ac4dd1339d7fd95638140f9743b69d96efbc04e56a" => :catalina
    sha256 "67b3ebe76e31e225ba583a1646e7dd2d8d7c1170a9914c515b52a6c247b669ba" => :mojave
    sha256 "4ed18b67f9253692e0077f40ded757a954b9723a7a4309f5caabf12c5c3468f5" => :high_sierra
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
