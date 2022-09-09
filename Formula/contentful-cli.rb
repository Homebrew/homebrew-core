require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.15.5.tgz"
  sha256 "1ded1f16fb2758abc1a49b8a41c5504294c66cf16e132c12d876b3a2ebd8ca68"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "722744e8529f238378f9d2923f8f4cf1933daf9a866751dcb18ec59f6ba0443b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "722744e8529f238378f9d2923f8f4cf1933daf9a866751dcb18ec59f6ba0443b"
    sha256 cellar: :any_skip_relocation, monterey:       "5581350272914b87c695c4e9d7499b43e48401254179baeca78e8932d916097e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5581350272914b87c695c4e9d7499b43e48401254179baeca78e8932d916097e"
    sha256 cellar: :any_skip_relocation, catalina:       "5581350272914b87c695c4e9d7499b43e48401254179baeca78e8932d916097e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722744e8529f238378f9d2923f8f4cf1933daf9a866751dcb18ec59f6ba0443b"
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
