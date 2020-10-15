require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.100.tgz"
  sha256 "8e93ce31c09bf78ec50382ac8c34b9d930d02e9373bde063563adcfe20b85d15"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e7b1585a8e6ee91cd0600e16d3a2c0c7c8f33be30a2949a816a5e51689331089" => :catalina
    sha256 "4c56a00dd1384037dfc479f18c10a24b532aa640463ddc1dda12a1b85570bec2" => :mojave
    sha256 "077335b0063142db4127cc93d5b8ffdc55e25d3e8a8132018c919024cdd65dee" => :high_sierra
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
