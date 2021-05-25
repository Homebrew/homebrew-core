require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.6.0.tgz"
  sha256 "09077c63e2c299df457f404f858659ac523a3a53eeec74a3404e1b725a822af5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9c792952373ba94ba3c2fa5eafa4ab9eb375f7e61143949528d1ce9feb9afaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb269a97f6935b34a48432e5217cb4f86b035438f8872b31de5f593d03231199"
    sha256 cellar: :any_skip_relocation, catalina:      "cb269a97f6935b34a48432e5217cb4f86b035438f8872b31de5f593d03231199"
    sha256 cellar: :any_skip_relocation, mojave:        "cb269a97f6935b34a48432e5217cb4f86b035438f8872b31de5f593d03231199"
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
