require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.1.tgz"
  sha256 "26e7034984d51f5cc197a037c43e2c99749a185222576f15e3adb87ae4a3c743"

  bottle do
    cellar :any_skip_relocation
    sha256 "a67a26466fc8cb5c3f1f58122093ef63c4b1f13489b9e9e147b8d53ea87361a7" => :catalina
    sha256 "85df11373e38fc87e7e8736297510784a11ade49d10b0c3828a06c8553eb788a" => :mojave
    sha256 "3b3d2921702930eb36ba62819e91d2eefc5f5c41e21cb40bd3ddc30defa22e8e" => :high_sierra
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
