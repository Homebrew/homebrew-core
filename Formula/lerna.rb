require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.2.tgz"
  sha256 "61fd4da993723f85b9a857276898dfedcc57c5b59828b0db014b9fd09940e5ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a79a556019a5bb27bc89d17e2207bef01e22ccab5c0b17d4900d2cc243d7f7c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a79a556019a5bb27bc89d17e2207bef01e22ccab5c0b17d4900d2cc243d7f7c4"
    sha256 cellar: :any_skip_relocation, monterey:       "1ad6f34e1d1fce7ad2954f91816467dfb581464776cfdd42235f66b054804195"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ad6f34e1d1fce7ad2954f91816467dfb581464776cfdd42235f66b054804195"
    sha256 cellar: :any_skip_relocation, catalina:       "1ad6f34e1d1fce7ad2954f91816467dfb581464776cfdd42235f66b054804195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79a556019a5bb27bc89d17e2207bef01e22ccab5c0b17d4900d2cc243d7f7c4"
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
