require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.6.35.tgz"
  sha256 "b498a091975d2f7deaf01b36194b7fa9fc401bd73ae498f40c37a7621418e468"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2086cd18266af926fd730880017382dc7480037a582b70a7a2d99173ce7e7d7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "14d98ab072c64ef72bbaf6d71fbab6076ca1c203c1d853f9c336365577b9fa31"
    sha256 cellar: :any_skip_relocation, catalina:      "14d98ab072c64ef72bbaf6d71fbab6076ca1c203c1d853f9c336365577b9fa31"
    sha256 cellar: :any_skip_relocation, mojave:        "14d98ab072c64ef72bbaf6d71fbab6076ca1c203c1d853f9c336365577b9fa31"
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
