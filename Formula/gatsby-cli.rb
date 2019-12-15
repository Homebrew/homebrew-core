require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.19.tgz"
  sha256 "a0e7ab76a903700d4adb5b48206f8f46600a3c855d0ee6c0bbec2ef99651c060"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba6cab8a7f73e25ccbee7903c22bc9824ab7c2127aadddce7a641292b84d139b" => :catalina
    sha256 "151793270378da68b910408a789548536c892a5b7f9e673da5d2ba853aaba926" => :mojave
    sha256 "2734c7ffc061b8f9ef8244cc33acd6bf315757c7db8643e4270550c07de1229a" => :high_sierra
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
