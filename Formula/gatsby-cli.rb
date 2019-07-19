require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.16.tgz"
  sha256 "2102811d89d3cabe35c347af43c4809ce1fba29ca33e9825748b7768654a49a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "54fde79041457ec39b2a7eb2db842b0a2227ef1743cf1ebc87e8f514487959bc" => :mojave
    sha256 "e9a754ed43d3ba76163b7a471b99bbc08c146885b1308b218f86d8ec919e60d2" => :high_sierra
    sha256 "aed71a4345f7f00d3c4c68fe1b12bfb0b1a0ef040bf2785a3bc0373dc58880a4" => :sierra
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
