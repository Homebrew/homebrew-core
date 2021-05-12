require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.6.25.tgz"
  sha256 "669851135164be1e872e1f6fb0f4147bc626f0b48d88e54832f5ccc024d2e533"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5487f10428bc7223b3a92e052f002cbba1f17ccf5e41e3701afc89d68d81aff8"
    sha256 cellar: :any_skip_relocation, big_sur:       "586aec98a54fd1eec24cdbc1292d5894cc6b1b14a0533ef1d3238abc3ddd6681"
    sha256 cellar: :any_skip_relocation, catalina:      "586aec98a54fd1eec24cdbc1292d5894cc6b1b14a0533ef1d3238abc3ddd6681"
    sha256 cellar: :any_skip_relocation, mojave:        "586aec98a54fd1eec24cdbc1292d5894cc6b1b14a0533ef1d3238abc3ddd6681"
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
