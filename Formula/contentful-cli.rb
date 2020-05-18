require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.32.tgz"
  sha256 "52ba6224ba603c73d13d06a72ee43652c5a2c56ac340b9672fd555d4bdbaab45"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a94192fc571cfc0a055e7514ed5d2d9e2b801e16635e6c13c391543d29af85f3" => :catalina
    sha256 "9056f9b72e2e8c5138dd65f48e363a5db2844dfb98d9f1630e77ad94f708c1c1" => :mojave
    sha256 "bd41c2d9ec8105ae705d58b385d68a98c6415b5e25586e4cfa95bf87faea2426" => :high_sierra
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
