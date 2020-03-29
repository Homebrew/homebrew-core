require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.11.2.tgz"
  sha256 "20d0937996fb419e00e4f90b9a9ac9c7b3022767be5b6ce0125c08baf9d1a70a"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5537065454b2e2c83618bcd42323bc0b20bc12a767f3bd9bca6bd0bf0864663" => :catalina
    sha256 "5345c81758a086ba36abcb3acc47fe028032745b384170c5899aaa8e4397a469" => :mojave
    sha256 "23f3b3443fd065d8a8888f7005158efebb45d00747d9f3e3bee5ef92a463b206" => :high_sierra
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
