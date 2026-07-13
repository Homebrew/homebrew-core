class Bx < Formula
  desc "Launch apps in a macOS sandbox with only the project directory accessible"
  homepage "https://github.com/holtwick/bx-mac"
  url "https://registry.npmjs.org/bx-mac/-/bx-mac-1.8.0.tgz"
  sha256 "d4f35bc7035b1d3509983bbf4c27c38da88481e6a3c308ba3181f30ebd319184"
  license "MIT"

  depends_on :macos
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bx --version")
  end
end
