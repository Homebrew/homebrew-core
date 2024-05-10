require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.2.1.tgz"
  sha256 "0da71d1a5264a7111e3b3ce8b73c898848ed421ff64276797a83f29ea5544aa3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d7186b12ee5afffa78c1f1f19db528c2a72393cbb2ca9431384a60a9a25dda1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d7186b12ee5afffa78c1f1f19db528c2a72393cbb2ca9431384a60a9a25dda1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7186b12ee5afffa78c1f1f19db528c2a72393cbb2ca9431384a60a9a25dda1"
    sha256 cellar: :any_skip_relocation, sonoma:         "452ae1e3f15478c6cb4b1a2ee2ffe701e5a9e4943ec634b19cf49a4455bbca42"
    sha256 cellar: :any_skip_relocation, ventura:        "452ae1e3f15478c6cb4b1a2ee2ffe701e5a9e4943ec634b19cf49a4455bbca42"
    sha256 cellar: :any_skip_relocation, monterey:       "452ae1e3f15478c6cb4b1a2ee2ffe701e5a9e4943ec634b19cf49a4455bbca42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d7186b12ee5afffa78c1f1f19db528c2a72393cbb2ca9431384a60a9a25dda1"
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
