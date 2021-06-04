require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.6.0.tgz"
  sha256 "09077c63e2c299df457f404f858659ac523a3a53eeec74a3404e1b725a822af5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5ef7218ebfc33a0985eead1feda6670cfdfe383eda7f4bef0e5fad838c2854b"
    sha256 cellar: :any_skip_relocation, big_sur:       "b3be394ca8b02fd405c6ec34faabecc960fb444562c8850a7ef4676744d182f2"
    sha256 cellar: :any_skip_relocation, catalina:      "b3be394ca8b02fd405c6ec34faabecc960fb444562c8850a7ef4676744d182f2"
    sha256 cellar: :any_skip_relocation, mojave:        "7993b95bf0dc288a8c56cf779a96b6984b70f772bf4a9df986d0f0be1b04f004"
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
