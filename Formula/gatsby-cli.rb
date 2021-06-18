require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.7.0.tgz"
  sha256 "5d6bdf197a35b96fcc2cff0ae315ff77a2d8e999c72fd9447e6e6a78253882f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d184cbd41f1475b9236ba6b60a75bb3fbd4bfd80eb002a000db798300524d4b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ab75c0d4ba5f47ac8af7ce550910124588bf0bbb108ece50679d7a288f5eaae"
    sha256 cellar: :any_skip_relocation, catalina:      "2ab75c0d4ba5f47ac8af7ce550910124588bf0bbb108ece50679d7a288f5eaae"
    sha256 cellar: :any_skip_relocation, mojave:        "2ab75c0d4ba5f47ac8af7ce550910124588bf0bbb108ece50679d7a288f5eaae"
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
