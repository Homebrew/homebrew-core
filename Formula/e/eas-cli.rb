class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-27.3.0.tgz"
  sha256 "1439ecb15f6c39e3fdb40a1682bc035b9e2e389edd524e94a7bd62c9d36e50a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4be6d634444fceecb0d975813dd67e9a452d0b0173434a8efaa035f0812d19eb"
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
