require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.14.tgz"
  sha256 "294372e6f5ab53b4b68b227cf27673bdde501d6ba69166edd62a6647376704a1"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9978efffae1dfc123bd4a1d570743073a7f3c5d419c682de40fe7cc84cb72fd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9978efffae1dfc123bd4a1d570743073a7f3c5d419c682de40fe7cc84cb72fd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9978efffae1dfc123bd4a1d570743073a7f3c5d419c682de40fe7cc84cb72fd3"
    sha256 cellar: :any_skip_relocation, ventura:        "5e3d66add22ae005e935317ffe6364a6eb6f40c1be857d7ca9fe73c8e6afaa12"
    sha256 cellar: :any_skip_relocation, monterey:       "5e3d66add22ae005e935317ffe6364a6eb6f40c1be857d7ca9fe73c8e6afaa12"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e3d66add22ae005e935317ffe6364a6eb6f40c1be857d7ca9fe73c8e6afaa12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9978efffae1dfc123bd4a1d570743073a7f3c5d419c682de40fe7cc84cb72fd3"
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
