require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.37.tgz"
  sha256 "1bb5cfa5cec16509b689102e997e8f6b8ac8d8682f8777c9f4b505c415aa9c8e"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a3cdd23956d84854731680754646ca8dd839f4f9f69798b251e0a113a4b46eb" => :catalina
    sha256 "926e6f34ea6d9e78bea3c9fbe54e813f06660288370b3672dfd04f655cf98f2c" => :mojave
    sha256 "9a2d1f3baa5400d60e13eaf1399cb23ef379816f5c9fbde6d52de1faf4c9f7de" => :high_sierra
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
