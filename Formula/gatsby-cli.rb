require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.6.tgz"
  sha256 "886ab128525d8a3f82243003078c682eeb4c6e3abf60114cd563db36b522a4ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "401d1e8347f77fd624ddf452b23dcabf108f8e4b99139936b23e788a91285cc8" => :catalina
    sha256 "d48f0207dee2f6fe10e115b445b2421eeedabf26db064665bffa61d368196bc7" => :mojave
    sha256 "a4e5c406f9ba5b8b4b58395011b2e7edf3c806e92b74c4982ee88afba09fab0e" => :high_sierra
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
