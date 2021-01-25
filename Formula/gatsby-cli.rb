require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.18.0.tgz"
  sha256 "6889094114512d15220ce75d257df54eb36fcd156cca3777b05e41f3fa510724"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "05cba87201abce99ca205f99350bc38219543fbf9c5ffac3741336ab143113af" => :big_sur
    sha256 "4c3a983a5eb9ed64c484bdc04aff7201a273be7abd76daeaa8e33366a38789ff" => :arm64_big_sur
    sha256 "ad5e7dcc0760ceaa0d960a28c5a5a70c80bc7eba8b720f691a15887bef81236a" => :catalina
    sha256 "36426930e2a3243a82f62297703966babd11de53d9c4703da5bd90feb513316b" => :mojave
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
