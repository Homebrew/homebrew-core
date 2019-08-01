require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.24.tgz"
  sha256 "4eee3cb7d873f8357adfc22683b0710bfdbce04219132f92e9d13f84c781100f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0495012154194570dd4df8bb4f3722d4330bd6d358bc335d652df17207457bf5" => :mojave
    sha256 "95011d33f7e064f54424db8f385aa9d175f8329bd8695f132aa6abcfc72ff821" => :high_sierra
    sha256 "44ce943620beaa2ef94f694a5f4f0fc2dd0e67ee8034186a50729ad53defa353" => :sierra
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
