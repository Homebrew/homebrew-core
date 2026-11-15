class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.10.0.tgz"
  sha256 "ea752ac4d1eed0d847396d42646f05269ee3e7a71521eea9e1c6f2a651312950"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b1399d00951ce3fe920466ab57e17b16764c1c45811490b4cb29b4d2ac68f45"
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
