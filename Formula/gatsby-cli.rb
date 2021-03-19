require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.1.0.tgz"
  sha256 "700b5ba49d5506a96f057934c3c55dbebba7543bb9a4c8e6d0d021a5e0aeb3eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b8eac78b3b56f72f515245e9b69b723fe108413db1d458f4d758cc84cf0a47a"
    sha256 cellar: :any_skip_relocation, big_sur:       "0cfb33a69794490c0ea899a6e448c3c6f1842a4467c285d68d2afb331f885ec3"
    sha256 cellar: :any_skip_relocation, catalina:      "83a25c0105c0770d5256d2f0c862016cb53370780a2866ce74f11f05c6042d8a"
    sha256 cellar: :any_skip_relocation, mojave:        "9211d5a4bc06b2ea35f95ed0aa6c844a677d5e2d6f92a687369188c791063427"
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
