require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.9.tgz"
  sha256 "f8f09e9b9b188709c89305f1dd99d9bb1a52664c20321bbd6e3b96ee03a23332"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc2af0f898f81d4130b8c00c0712e3f61a2144a7b962a4e9d76340ed52d05791" => :catalina
    sha256 "d0a8cb2c0cf4c1a2665b1815a3cb41cc6d411c4f1f4a89ab24979e1d9c73fecc" => :mojave
    sha256 "8b375fc134079be810e6e7df5d5f6650966d53000c93d5a9895048b62ccc9bd3" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
