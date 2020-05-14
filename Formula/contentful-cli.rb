require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.31.tgz"
  sha256 "b6f3ff6ca7c50a4a1e0325c23a687b74bae3fdb2effd2bbd06e6179a15ad510d"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ff61e6eb13caa19e97765fcdf6b56694bf0d22dd3119ea589646cbacd32a426" => :catalina
    sha256 "daa96637d5ccf989f5f0b66e6f7efc1a0344b7c42f22b83ae2736d55c64bf7f9" => :mojave
    sha256 "9559dc892145a25868a31dab81424b64eaa9e0649eaf2eb3df166a4538b98b2c" => :high_sierra
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
