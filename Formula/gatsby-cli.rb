require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.1.tgz"
  sha256 "6838028a297332fbf50dff9634367e3f21b816a90929fb90c85575c5cb765945"

  bottle do
    cellar :any_skip_relocation
    sha256 "1473f257cc181f0e60b4ef6f6467a6e9be8946b5dce5998e4aa6b1fe5cc68082" => :catalina
    sha256 "1d6aad7c61b9a25b856b9b50679cc346358b63bad31413c3827a704e0d3d8b0c" => :mojave
    sha256 "94d0184a8d8fc311040d8879dfa933a7c00355321fb86e519eb554e8a8f99140" => :high_sierra
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
