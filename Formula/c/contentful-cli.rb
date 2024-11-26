class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.6.4.tgz"
  sha256 "bf379d1c75e7f91e4999b4f2c1efa6f076890fbb473a40dc69ebd2585462f478"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a8d0accb8429697d0329d675a2d9cf81892e56d818af45e821f0b1ade0f5aed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a8d0accb8429697d0329d675a2d9cf81892e56d818af45e821f0b1ade0f5aed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0a8d0accb8429697d0329d675a2d9cf81892e56d818af45e821f0b1ade0f5aed"
    sha256 cellar: :any_skip_relocation, sonoma:        "427d9095c822a8f121ecb7729cfc3c327233bc99c8c93b2627134392c522cd6a"
    sha256 cellar: :any_skip_relocation, ventura:       "427d9095c822a8f121ecb7729cfc3c327233bc99c8c93b2627134392c522cd6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "338f03ea7bb0fed3162047bfb6cb91a55be2bf63ed654276f5ece290ba782027"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
