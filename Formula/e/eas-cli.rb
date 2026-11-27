class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.11.0.tgz"
  sha256 "b4d159a7c202a0ddf9e96f63f9cc8a571811f63f341cefa0f0194881526a2be8"
  license "MIT"

  bottle do
    manifest_sha256 "b6904003b2d04a37c03ebcd3852b7d88fd1b29684e65aa66c081f4539b62c069"
    sha256 cellar: :any_skip_relocation, all: "070b104766d43928116364a8c6f45acfc33304f035950fd49ddef7e3445b7b6f"
  end

  depends_on "node"

  allow_network_access! :build

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
