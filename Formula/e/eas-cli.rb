class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-20.5.1.tgz"
  sha256 "6d2d4dd92c2a5cfe2c288dfc12d67b40a0bd2ef5d9c3d40077f61221d3ef3fee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3456e8ad9c29cef61c372c10b76ab0792197417cb180f01cf2f3ae32d6d4dd55"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
