require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.4.tgz"
  sha256 "d98e8ad054ff1da9c96897c273623975a10d4b0dce1549306fe7a91a6e6d5e91"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7be3e4f7cb6df4efd5bd3d18ad6b8c01074e85ca6aff5b538677ccd69b1ce54" => :catalina
    sha256 "200cb11d397a038d7b48be273e6b9a0236937cbb1ea7e9fb33472ddf91b3da46" => :mojave
    sha256 "0712bc16636fdf258644aef64736fe4b187100c52a545ff2492d6b3daa012005" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
