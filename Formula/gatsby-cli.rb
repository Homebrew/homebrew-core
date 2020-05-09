require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.15.tgz"
  sha256 "aca45532e0aa9e3d455a0a2a83cc9ce2b4f56a3703082c7446ad7afeaa5cf5b1"

  bottle do
    sha256 "5eedf7c39f8c845ba3c6146b4d7bdd342a95e439b8166226f33e89deb59bc03c" => :catalina
    sha256 "52f2970da8bfc9175d41deec093a35396aad38cf7ad0ee167c789a6a19ab5f10" => :mojave
    sha256 "629781b36e365c5d06f16a4947c842b2dc5a75cc203ca5619cf6bfda048c18e6" => :high_sierra
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
