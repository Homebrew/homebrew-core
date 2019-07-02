require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.7.tgz"
  sha256 "2f73bc0b31a5d65fca819f9eafeb9da5a6026dbc07f77349adcbd9f3edb2af9b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6b96365db88c0b7e54e7c3ccf2502d73878a623413c1f5d5b153d596f0afe3e" => :mojave
    sha256 "769d0aefd21f0ec6e7ef51dc7f4e17b15db6d9e275c8da5e8ca54113b720bbb0" => :high_sierra
    sha256 "f1cb5f08732e0db1ea144a0475a83c354ac3f8d774008cb1c53745c1b6392dee" => :sierra
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
