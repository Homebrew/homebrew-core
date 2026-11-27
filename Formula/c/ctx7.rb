class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.13.1.tgz"
  sha256 "59fa5ea206df763b204dc67e98bf1458cd05f0f7d5b2ab15b1fb34a0d0d270c0"
  license "MIT"

  bottle do
    manifest_sha256 "39db18b5bbe9ca15a55b9e504df0c220aa65a55eb6bfef89dbe7106682a73a57"
    sha256 cellar: :any_skip_relocation, all: "6c55eb4b10a35ac920e9d9ca184f3adb78d3d07d769547ff3f3cf5f9566fdfbd"
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
