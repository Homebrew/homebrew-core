class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.11.1.tgz"
  sha256 "ceb148f2988a62534390d3ff58c3f73bd339d8d947f6586cf9eb0f78861000a7"
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
