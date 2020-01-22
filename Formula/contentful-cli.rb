require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.10.tgz"
  sha256 "ca1d19f783c464ed866cf9a081fac5783f11d6486eebeea001a2c64dae34b2a7"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e12611ecf6e7ee22f11ed76a4c02d7e1c2eb481a003f271fcc96b407ccc7c8b3" => :catalina
    sha256 "39bcf7826c763b7af0b92f4960ec0b6b4bb802f21957e30d145093a9832913f0" => :mojave
    sha256 "2d4dd91ad53c21c1611d0ab060d766ddac71f36d2d2230543a7fe92e68048c8d" => :high_sierra
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
