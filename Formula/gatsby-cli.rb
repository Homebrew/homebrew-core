require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.3.0.tgz"
  sha256 "d8dbbcffdc67708daa630bb40154ce39dc4815e48137e4eec93966b7997b9f3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cacbe58fa5506a4a7000fcaf6823a9499f2c5e44c5f620e8e7cd27b77b859166"
    sha256 cellar: :any_skip_relocation, big_sur:       "50982c08bec3d306ba2ba9b8b1f7438a900f536443ae1948fefa29b1e4c39847"
    sha256 cellar: :any_skip_relocation, catalina:      "50982c08bec3d306ba2ba9b8b1f7438a900f536443ae1948fefa29b1e4c39847"
    sha256 cellar: :any_skip_relocation, mojave:        "50982c08bec3d306ba2ba9b8b1f7438a900f536443ae1948fefa29b1e4c39847"
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
