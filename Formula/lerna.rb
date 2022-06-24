require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.6.tgz"
  sha256 "dbdd482c494a146a14e33f11ec7b8e10d248512318b9e2da829c9471da9c3e95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edd0701db7140f583528e81d2ea964bdb0b074b6c8630ba82e0f343f077306c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edd0701db7140f583528e81d2ea964bdb0b074b6c8630ba82e0f343f077306c2"
    sha256 cellar: :any_skip_relocation, monterey:       "0e0b1df8945af1f3966465ea91bc29246bfb2e0faae0fa87be2977bcf4eed9c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e0b1df8945af1f3966465ea91bc29246bfb2e0faae0fa87be2977bcf4eed9c9"
    sha256 cellar: :any_skip_relocation, catalina:       "0e0b1df8945af1f3966465ea91bc29246bfb2e0faae0fa87be2977bcf4eed9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edd0701db7140f583528e81d2ea964bdb0b074b6c8630ba82e0f343f077306c2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
