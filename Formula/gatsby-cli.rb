require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.37.tgz"
  sha256 "5b778bdc8f365931497daa758363a4ea8b26451ae1626bbe09f9265271ea2a59"

  bottle do
    cellar :any_skip_relocation
    sha256 "26a84da0a831b79b4725c7d468510c7740d3edef9910f0bd7b321caccf962ef7" => :catalina
    sha256 "8812e72ef14b683a58f1160ae7d9673e5515446af88678c345d7513a8b668252" => :mojave
    sha256 "a3043c14376866799a7619bb3404c1a2601f5d4738c5de5ff4f4494f07202d9c" => :high_sierra
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
