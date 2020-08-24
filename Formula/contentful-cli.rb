require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.26.tgz"
  sha256 "ff9948f565785ace310fe8a1edf13abb72584dfb59da4c0ccff354a7be3d90d8"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "feb3a9fcd602a1faf50189151b735c2f63254e00ad3269aa93c40f9f3119176f" => :catalina
    sha256 "be34837cf4e4542358cbf8d9ff9531473e36ad810f885c752ab2443bd3640f37" => :mojave
    sha256 "449e4f2c0d75d0878eeae0a5ade4f986a4372a0f8f285cb0fc20fc60d78ff70b" => :high_sierra
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
