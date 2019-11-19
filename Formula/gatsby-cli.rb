require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.12.tgz"
  sha256 "198fc4e615fdf60a03e53e360cee324e0a086b969ef4470eea2587a3100ffbd4"

  bottle do
    cellar :any_skip_relocation
    sha256 "64e922ed17578e9518f5a84c91e278038b6a5aca8ad7ff9661ccc48dd47f8d3a" => :catalina
    sha256 "639e5c23fb1858bccb93a45a76bfd3d857368d4be462a286365a4d7d987cc4a3" => :mojave
    sha256 "09b8b54934cbf5b0f308334a94d2e7b35f6ffc7575e5e4548a0b47b7052212db" => :high_sierra
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
