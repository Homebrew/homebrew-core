require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.110.tgz"
  sha256 "c2c20cb077faa904d4552a2218effa4221a73c2d9683e23be0c8d6fa7732768f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b6cbd16098685d4e27fb2d7515b07dee48b02e5e9eaf489297a0413cf60199d1" => :catalina
    sha256 "7d7378c5989e495c1552d3d640326a618a3824aebdf0c13a45de6a0a883f6135" => :mojave
    sha256 "0367d0d2a0fb575c2a1f456c470e7057fa14f8e6db85184343aaecab5f8d3c3b" => :high_sierra
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
