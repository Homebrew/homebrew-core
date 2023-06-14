require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # contentful-cli should only be updated every 5 releases on multiples of 5
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.20.tgz"
  sha256 "f12c2a9ce5b96c29b410d4fc34f0604e2de0da624578005aaa1a40f1b4c96a13"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf6c885ed137ccd3339f503223a954e2e658e7f9ac80ee109780581b81dd1e61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf6c885ed137ccd3339f503223a954e2e658e7f9ac80ee109780581b81dd1e61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf6c885ed137ccd3339f503223a954e2e658e7f9ac80ee109780581b81dd1e61"
    sha256 cellar: :any_skip_relocation, ventura:        "0af7d449a81cb5a358f6506a6e58ede3f87dc3c660dafd420952e4c58f74a3e0"
    sha256 cellar: :any_skip_relocation, monterey:       "0af7d449a81cb5a358f6506a6e58ede3f87dc3c660dafd420952e4c58f74a3e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0af7d449a81cb5a358f6506a6e58ede3f87dc3c660dafd420952e4c58f74a3e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf6c885ed137ccd3339f503223a954e2e658e7f9ac80ee109780581b81dd1e61"
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
