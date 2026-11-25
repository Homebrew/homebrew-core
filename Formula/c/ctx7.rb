class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.13.0.tgz"
  sha256 "0d0b26ea5386b7deec99ec916574931db9c48952f7b6bbc15a68d69a9a861b6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e0fdbce97ccceba7aa1676347b1cf583cb0871c13e10f2ca5cddfd4ff6090da"
  end

  depends_on "node"

  allow_network_access! [:build, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    system bin/"ctx7", "library", "react", "hooks"
  end
end
