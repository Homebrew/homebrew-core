require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.50.tgz"
  sha256 "5583c7079977a8127f8732e225e88432c284512371040f592c394381e2379d98"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cab711a7bffce69907880abb393f23cbf20041a031e5b4346bd16e1a802d696"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cab711a7bffce69907880abb393f23cbf20041a031e5b4346bd16e1a802d696"
    sha256 cellar: :any_skip_relocation, monterey:       "4dbe4f0edc3b6f7adc1704834e80d34a87924043faa3f8827ab3ae0a3828f298"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dbe4f0edc3b6f7adc1704834e80d34a87924043faa3f8827ab3ae0a3828f298"
    sha256 cellar: :any_skip_relocation, catalina:       "4dbe4f0edc3b6f7adc1704834e80d34a87924043faa3f8827ab3ae0a3828f298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0f0cb1da6a045a978e06fe4dfc663781c09e694f9958ade2fa007b68731e81a"
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
