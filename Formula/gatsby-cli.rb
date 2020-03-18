require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.12.tgz"
  sha256 "d0649b643fd786d8c48ad073bb352d3602d88f05a9d0f92fab04b68be0ea9aef"

  bottle do
    cellar :any_skip_relocation
    sha256 "1286844bd4115aa24534fb0abb2a2da1c66e030db98e72e49dffe256983c8a50" => :catalina
    sha256 "d45d32a9b5f18367c3f8121854837bb69c0b5ff144e93b29ca16c819c3f298b6" => :mojave
    sha256 "f1eb65fd82f6fcdec227a1fa0385ce1daaa306f6bd8f2b079c4af84150b66d42" => :high_sierra
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
