require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.26.tgz"
  sha256 "5944b6fb2410662ba30e8aebd892fd60f3a41ac5a2e60ef820758f23ef673a9f"

  bottle do
    sha256 "ba4abad823d9a68db6c550442653c3a4e91ee13d73c7f5f6b742ae9bbfb5de7d" => :catalina
    sha256 "3554919259258e53882424d1362c3b350e729758f038ce20b106d0995aaf6db2" => :mojave
    sha256 "ce93ec07515ea23096809b78b7acf069441198267f4bc29cb9ba9f267342a4b4" => :high_sierra
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
