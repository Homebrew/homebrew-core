require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.1.0.tgz"
  sha256 "fb03e3409de92fe62fa98607f1d1e64a1c6923f985cc4990ec9e36cb46c3ca71"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6026835ea0064c46fd05c6e645af7eb70208a8160c6a61c2eba1f5f8ff64aad6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6026835ea0064c46fd05c6e645af7eb70208a8160c6a61c2eba1f5f8ff64aad6"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ae18f13cf430bfbfff62dc486b83f1f4c1e7c0009388020e1557ff61ddfc82"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2ae18f13cf430bfbfff62dc486b83f1f4c1e7c0009388020e1557ff61ddfc82"
    sha256 cellar: :any_skip_relocation, catalina:       "d2ae18f13cf430bfbfff62dc486b83f1f4c1e7c0009388020e1557ff61ddfc82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6026835ea0064c46fd05c6e645af7eb70208a8160c6a61c2eba1f5f8ff64aad6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
