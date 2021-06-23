require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.8.0.tgz"
  sha256 "06d4242f85e6291ce3a7798d171f3642d54320d5995731b6cdedb51e80eaee7c"
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
