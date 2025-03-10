class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.7.12.tgz"
  sha256 "7eea8c9c44c61a57e9bc4f195d0c9cc2c6b7013d8d06b849ebef5d45256a5620"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae080f9cbdc2fec1e803eee886859323ee773e879cbf47ac801178cdb05f13d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae080f9cbdc2fec1e803eee886859323ee773e879cbf47ac801178cdb05f13d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae080f9cbdc2fec1e803eee886859323ee773e879cbf47ac801178cdb05f13d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f711535b2031419cc7135863cb0cad8f67009672c289cfacf72e5744693f4fd"
    sha256 cellar: :any_skip_relocation, ventura:       "3f711535b2031419cc7135863cb0cad8f67009672c289cfacf72e5744693f4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c740bc0635f0127a91b5761cbd2994019a4defc17ea2c05107e5e58bd40cd09"
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
