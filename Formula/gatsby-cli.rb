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
    sha256 "8c40749f4e362ad58e1312428882f13e1cedc3cf612ca02d82fd9efff7d898c0" => :catalina
    sha256 "dedfd0cdfeaf1238995b448e68d847c52d4a8c942fe5eb2eb30acc84930f9540" => :mojave
    sha256 "731794bbd7da8e7e18d38e0f41e7950ccaa33cdb11069f6de020d1a011aad2c5" => :high_sierra
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
