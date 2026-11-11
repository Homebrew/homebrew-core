class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.7.2.tgz"
  sha256 "edfd254b288936203df72355836e3bd5e16fef6206c3e84088fc300b7ceb6f33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf4ea3737bda5e6ff09b13fa0c9a7f6928f5bdb1f2f70c8ffdc9a716d11d3b2e"
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
