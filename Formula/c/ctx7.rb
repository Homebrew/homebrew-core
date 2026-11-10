class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.11.0.tgz"
  sha256 "068f0df5b9ffd0e67ec917dec41fb7845aa5183d0c2cce5b29510c17f69d8ef1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "978b254437ee34b99d94bd0e95b15340c498dca9811b62568d0a3f4ff2360129"
  end

  depends_on "node"

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
