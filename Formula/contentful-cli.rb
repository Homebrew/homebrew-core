require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.22.tgz"
  sha256 "a08ad9920e99e3d4b3afc65ba772e7d6d3f11a58e50f3004625fcdabf59b3955"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecd6881db49bebb76e259d71481152025e5913a0db416a896e68cd406fb76fef" => :catalina
    sha256 "0beb35bc55e7f94d80d8f9762afeac0a4e2bec230c2cef9ee2262695b05e63ee" => :mojave
    sha256 "58c2ad1a8636e8efe55f4e6ec6279a7e73b5788b333f0fe0d64b2d54cdac5234" => :high_sierra
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
