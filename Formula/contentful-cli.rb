require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.8.10.tgz"
  sha256 "4149e29df422b6584d64d4b9d81c95648ed4543835ecfb3e754d0794359d427d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc57c96d38c32fb002ebf0936abb90414cf46fd12a0bf350d2098b2a3ba97746"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6cf9057bc83a1e3cb035ddfc2ff74fd26d1d72c1d27a89f5707804c64812aa1"
    sha256 cellar: :any_skip_relocation, catalina:      "a6cf9057bc83a1e3cb035ddfc2ff74fd26d1d72c1d27a89f5707804c64812aa1"
    sha256 cellar: :any_skip_relocation, mojave:        "a6cf9057bc83a1e3cb035ddfc2ff74fd26d1d72c1d27a89f5707804c64812aa1"
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
