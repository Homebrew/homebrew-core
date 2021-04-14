require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.3.0.tgz"
  sha256 "d8dbbcffdc67708daa630bb40154ce39dc4815e48137e4eec93966b7997b9f3a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5aa86cc2b36e7fabf59388cc7801358bd9109cd365c09ef60c55438c451610a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c4a0fd325dfedb3a2dee7314c1019297854c0e595729fe8c2bb689c62dde9be"
    sha256 cellar: :any_skip_relocation, catalina:      "39fdc9d1b55a2bccdc44d4248618ac6f81a7f63daef0f8146845c0ddeff71d5b"
    sha256 cellar: :any_skip_relocation, mojave:        "cc16f8ec789976af39ee395dc3c991f983b3de2609f68c80f0f485c95b23f993"
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
