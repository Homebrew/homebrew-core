class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.5.0.tgz"
  sha256 "4abb8bc6d0ad969cabdf7c45d6b2d47a33df3d9e74d59ba9e65a13a0eff1256a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa28f8957b6cef6f73be6dc5b4d5f50e7767c5ff2515d6186a120817d6cf02c5"
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
