require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.7.17.tgz"
  sha256 "3cd04c5abc4dd36d271a59374f3618c24d77463036346a92d45d2aa651e30c8e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ac4ef954e4ab50be0fe2f8ff1a139f9bcbcfc8da227c95d83a9fa87a01e779e" => :mojave
    sha256 "b021929532e7b8af3c75a2b11d42546494347b9bc80f2a49ec2c8b254def2df7" => :high_sierra
    sha256 "e84ac1b5da67605288072fd33412cb314a22157e0cc4594a5cb85ef715c9ae85" => :sierra
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
