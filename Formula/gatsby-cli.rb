require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.90.tgz"
  sha256 "37572b832940c61b58a288c816e41aefefb6356a4ac4a7b567a6216e67a3954c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4c1c54fd99ced82cd9fb2f854c2be68991e46f5d5063732666a29138b67778dd" => :catalina
    sha256 "9f94aafd629980e8035ce1fa130836358a703e4f045d6d8192193c3676fc9a26" => :mojave
    sha256 "5a53bebb224788f888e9e08adce4cd7f01d58368b178cffa957aae3a84798f5f" => :high_sierra
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
