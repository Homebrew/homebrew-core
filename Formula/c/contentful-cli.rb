require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.3.tgz"
  sha256 "a58a21e2a519550a15863b49d368ba9599d04e34fd9ec097878a9b58cc1bfe74"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9276f00dff2dde85bd8712b55114c94a43541f81ae1030225d496c10de8f248a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9276f00dff2dde85bd8712b55114c94a43541f81ae1030225d496c10de8f248a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9276f00dff2dde85bd8712b55114c94a43541f81ae1030225d496c10de8f248a"
    sha256 cellar: :any_skip_relocation, ventura:        "98a62378b79fc517fbe6b53c732dea03e7062c67035bb033a2214de23b054634"
    sha256 cellar: :any_skip_relocation, monterey:       "98a62378b79fc517fbe6b53c732dea03e7062c67035bb033a2214de23b054634"
    sha256 cellar: :any_skip_relocation, big_sur:        "98a62378b79fc517fbe6b53c732dea03e7062c67035bb033a2214de23b054634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9276f00dff2dde85bd8712b55114c94a43541f81ae1030225d496c10de8f248a"
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
