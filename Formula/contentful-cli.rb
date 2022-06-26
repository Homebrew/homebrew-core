require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.14.15.tgz"
  sha256 "60d7b3724d56220a97065121987f385f389c157820ca7921406885358d850af6"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b193cd0a8a423a3d2bf51e57905b56cbe6f4121fdcd7f9677b6331b74169c5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b193cd0a8a423a3d2bf51e57905b56cbe6f4121fdcd7f9677b6331b74169c5c"
    sha256 cellar: :any_skip_relocation, monterey:       "40f1308771ac3ef2f7c389b4a6c6b411f30e6ad8e8d59b53b45fc1d49c9c9c1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "40f1308771ac3ef2f7c389b4a6c6b411f30e6ad8e8d59b53b45fc1d49c9c9c1e"
    sha256 cellar: :any_skip_relocation, catalina:       "40f1308771ac3ef2f7c389b4a6c6b411f30e6ad8e8d59b53b45fc1d49c9c9c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b193cd0a8a423a3d2bf51e57905b56cbe6f4121fdcd7f9677b6331b74169c5c"
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
