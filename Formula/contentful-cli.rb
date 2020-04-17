require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.16.tgz"
  sha256 "b5f2e242f613756664fb9563cb6374c4b23187b458c4f5b20c4be4803dde3e22"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa9de3ba601ae69eb6a90737ac0cff203fc56027ac24fcbcfa0551bf18d1c305" => :catalina
    sha256 "ad15018573a44d0b10f10b86b01d6f1fd1772b7c1550a5548f390e141557bc78" => :mojave
    sha256 "38a3a7a84d1bcaf05adeb21a6ece84ecbfd3733b43d977f6aeb75b472503d25f" => :high_sierra
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
