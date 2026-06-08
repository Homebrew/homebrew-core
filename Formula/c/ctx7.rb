class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.1.tgz"
  sha256 "4c0d5dfdba69baf41bf2b62394720747f6aaafda1db2049d9977f366bc75044e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43d30cabfeed568d2200d2440e2a86aa7bf4a361ae5caaf1ed36660ffde6e112"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx7 --version")
    assert_match "Not logged in", shell_output("#{bin}/ctx7 whoami")
    assert_match "No skills installed", shell_output("#{bin}/ctx7 skills list")
    system bin/"ctx7", "library", "react", "hooks"
  end
end
