require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.10.2.tgz"
  sha256 "bfaaca1d8000d5dece9158589d0fe60ee0c02bbd4b4065ca1526360fc7c5bb7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0327f9e2d1187b79c5e17e5422357d7c09bfd288276c5159172bb35a6bc03d45" => :catalina
    sha256 "a71c4b3d2ada005d88849f2ead0b83b3007d5511aa683c295b9a4df0f342de69" => :mojave
    sha256 "a2c621f16fdc87db0dd0b74713821e6f465394ede56dd989275491219a995541" => :high_sierra
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
