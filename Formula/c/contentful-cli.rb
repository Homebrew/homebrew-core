require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.0.5.tgz"
  sha256 "ed7f100c7f6ffaa78ab80d53fe0e9c3fab3a8929aac8a223dc4363322a7292c7"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c33f9334443481855bd976083cd55669b429a303f9616f1f7de8116e64ed061c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c33f9334443481855bd976083cd55669b429a303f9616f1f7de8116e64ed061c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c33f9334443481855bd976083cd55669b429a303f9616f1f7de8116e64ed061c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2a8f8907ac47422dc8b7feb3a880e3ac98797f1a06261c9aabe01c2d779c5b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a2a8f8907ac47422dc8b7feb3a880e3ac98797f1a06261c9aabe01c2d779c5b2"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a8f8907ac47422dc8b7feb3a880e3ac98797f1a06261c9aabe01c2d779c5b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c33f9334443481855bd976083cd55669b429a303f9616f1f7de8116e64ed061c"
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
