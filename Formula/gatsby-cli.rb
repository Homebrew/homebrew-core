require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.26.tgz"
  sha256 "8380d6dfe588621e745ad7f0e63ea7e52244461852fb264d80ae41c67238ffa5"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7a58cc3e326a9842773eb4f0036defc537e2f1009e58b5473c176ec4f496482" => :catalina
    sha256 "760647b91a422f74cb956c25bae0ec1e579e9d9d8e47d495c9cb851912bb24ce" => :mojave
    sha256 "3a7e6187a80bc5ec4ee451e085ee2ac48c3a49f3135a7ed37916b89af0b50279" => :high_sierra
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
