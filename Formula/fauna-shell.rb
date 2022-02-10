require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.14.0.tgz"
  sha256 "8aff6b0549f9c3713695582c0b8ab36d2e37d441d1d7fd0fd413ea769e8aaa39"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "332185f41f747f74c967569beeba9c4d6b7ed80a940b9b777137eb31be52da47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "332185f41f747f74c967569beeba9c4d6b7ed80a940b9b777137eb31be52da47"
    sha256 cellar: :any_skip_relocation, monterey:       "0b4a663a9fb83b5688f642abaa6df423d2c3b080d8025a2f8c80eeb298f330f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b4a663a9fb83b5688f642abaa6df423d2c3b080d8025a2f8c80eeb298f330f8"
    sha256 cellar: :any_skip_relocation, catalina:       "0b4a663a9fb83b5688f642abaa6df423d2c3b080d8025a2f8c80eeb298f330f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "332185f41f747f74c967569beeba9c4d6b7ed80a940b9b777137eb31be52da47"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_match "fauna_endpoint *\n", output
  end
end
