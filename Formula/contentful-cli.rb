require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.9.tgz"
  sha256 "fca1d9640d37986b5c01bd5e9f37c09b803805d4497fe4d0d00283dcac51f28a"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49ffd4ae7ddf7d1581818dc890ed9f0a477df427a5b1e404f63116caa58ef11b" => :catalina
    sha256 "7c854f0266c1f507599ca4978c837347e4403a75e91d3a9904a298452fe62d9f" => :mojave
    sha256 "182050ac3d0c8233810a232f367e03f96e77efb98a2ee7b92b36fe902b4695d5" => :high_sierra
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
