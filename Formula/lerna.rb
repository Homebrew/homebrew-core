require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.2.tgz"
  sha256 "61fd4da993723f85b9a857276898dfedcc57c5b59828b0db014b9fd09940e5ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "016e6897f2049259f8c5d97bda0a2b8f1f1a8028edf6903d65ba3bf8eae22345"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "016e6897f2049259f8c5d97bda0a2b8f1f1a8028edf6903d65ba3bf8eae22345"
    sha256 cellar: :any_skip_relocation, monterey:       "1edfa12cbeadc1cfda828794164572c7c63cc3e1db7fe2d9373f1ef297331e08"
    sha256 cellar: :any_skip_relocation, big_sur:        "1edfa12cbeadc1cfda828794164572c7c63cc3e1db7fe2d9373f1ef297331e08"
    sha256 cellar: :any_skip_relocation, catalina:       "1edfa12cbeadc1cfda828794164572c7c63cc3e1db7fe2d9373f1ef297331e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "016e6897f2049259f8c5d97bda0a2b8f1f1a8028edf6903d65ba3bf8eae22345"
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
