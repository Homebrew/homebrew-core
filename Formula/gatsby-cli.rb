require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.5.0.tgz"
  sha256 "cfe6244201614d4af56a2f6edb1daf99685239916259226f7b8b51964c3d5ced"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a764a8bca32f706d9499dec062e85c6862812a96d34a8e09534f634f6db3eeff"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea4c4fcb46d9f2c63068f201ad00b66160cd42280cfdd5699a6aaed185bf5954"
    sha256 cellar: :any_skip_relocation, catalina:      "ea4c4fcb46d9f2c63068f201ad00b66160cd42280cfdd5699a6aaed185bf5954"
    sha256 cellar: :any_skip_relocation, mojave:        "ea4c4fcb46d9f2c63068f201ad00b66160cd42280cfdd5699a6aaed185bf5954"
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
