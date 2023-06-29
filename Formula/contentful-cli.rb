require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.22.tgz"
  sha256 "7913b1bc88463145c89cc8d73087e759b39e53f3ab2b9ad33f50c31c74282d87"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa8cbf059c424089a57c970c01c53f039755e0cc86ea08db331de99ca883f774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa8cbf059c424089a57c970c01c53f039755e0cc86ea08db331de99ca883f774"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa8cbf059c424089a57c970c01c53f039755e0cc86ea08db331de99ca883f774"
    sha256 cellar: :any_skip_relocation, ventura:        "674a8bfc27a81801c4246028bd0aecaadef0c288fabfff8cf23924f52273bbbb"
    sha256 cellar: :any_skip_relocation, monterey:       "674a8bfc27a81801c4246028bd0aecaadef0c288fabfff8cf23924f52273bbbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "674a8bfc27a81801c4246028bd0aecaadef0c288fabfff8cf23924f52273bbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa8cbf059c424089a57c970c01c53f039755e0cc86ea08db331de99ca883f774"
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
    assert_match "Or provide a management token via --management-token argument", output
  end
end
