require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.24.tgz"
  sha256 "0d036b76f72cff6a24b3e8ec4c788e2b9a2c2b63f613f92a4b2fc01b9f00b364"

  bottle do
    sha256 "c155d13941c3909954360aff3ad3e123351ebe7dd90ef03948767a8a37cd290f" => :catalina
    sha256 "534a081fe5c3ae16384ac4716afa6630fb91d48de00bced4baa9a7db106ba898" => :mojave
    sha256 "49dfe0dddb824d4cd62e8aec656105e1be5f8c1d36d45b98a24abf872a2c6c77" => :high_sierra
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
