require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.15.0.tgz"
  sha256 "d4224ff0ad9701d88a0911fc3ad5eea14bf508d49d00c07d5fceb16dfb89521b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7e14518950995abe75f8a5c5a0dfb49fd23bfea22d5c28787662da9ea3f8c09b" => :big_sur
    sha256 "5b0128cf9e00a03d05aec2cafdafa42792f5c9ff220fa09c4a8a6aa0a9a730fb" => :catalina
    sha256 "501df19565d8036daa47d49cff753e6f9d0d465324cb9d250eab79341f32277e" => :mojave
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
