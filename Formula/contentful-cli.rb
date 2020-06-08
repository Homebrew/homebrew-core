require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.7.tgz"
  sha256 "a7facf07c9d714d95a486e180f7af20b5255c8396d5293e7f2c19ffa91b39e0a"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe5aa6295d872aa146ca0b8e11e5cfe579e2d0459381256976db182c8e9b40fe" => :catalina
    sha256 "4e8ac82aaa6496e06a9cfbd5a95c11328b8bab2f6d54d700a40ddafe499e6989" => :mojave
    sha256 "c18561168e9409c346b0f12156c79e056a2aea7b70913ed76ce950a16cb0a2e5" => :high_sierra
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
