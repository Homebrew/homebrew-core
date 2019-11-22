require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.13.tgz"
  sha256 "cc6238c39a33c67281b96f2bbd0ae2dfd81b7b18ccd1db77f6559a8178f3bfcb"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d98fca2260322ee200b2c0e171f3f46d4077641fe348e22fb6629e0e65e5e3f" => :catalina
    sha256 "125f3e96982a35e191ae3c5773e846a571d1a977387df3b185c95127d53940d5" => :mojave
    sha256 "45ee046b4db8534b61aa858dc813fb5bd006c6489eadd4118b620beac0a1e3fe" => :high_sierra
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
