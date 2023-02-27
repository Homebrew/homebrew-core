require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # 1.19.0 introduced a big code layout change, which is not easy to patch.
  # TODO: re-add version throttling in next bump
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.0.2.tgz"
  sha256 "79cb14c517f0a29a131ab66c768ece676a4a4c0c9d359a370552e86f5f42886b"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ccd164b9a9d0cc1b02c3d539649cb92e64d9f0b214a8591e4f057b76568e555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ccd164b9a9d0cc1b02c3d539649cb92e64d9f0b214a8591e4f057b76568e555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ccd164b9a9d0cc1b02c3d539649cb92e64d9f0b214a8591e4f057b76568e555"
    sha256 cellar: :any_skip_relocation, ventura:        "1c4489ddcab86279d6fd4fdeb9582521027fb62d4b7e7efdfe58e83031360d98"
    sha256 cellar: :any_skip_relocation, monterey:       "1c4489ddcab86279d6fd4fdeb9582521027fb62d4b7e7efdfe58e83031360d98"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c4489ddcab86279d6fd4fdeb9582521027fb62d4b7e7efdfe58e83031360d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ccd164b9a9d0cc1b02c3d539649cb92e64d9f0b214a8591e4f057b76568e555"
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
