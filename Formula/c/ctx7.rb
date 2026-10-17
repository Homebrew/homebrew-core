class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.8.0.tgz"
  sha256 "15da7f0f2e99f75afaba571ac9de0d5ab7c640885c6638b3a3d99ae91b923d5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5639141d217ba1c712807de6a48011ccd54a061d348a8272fdf147337064054"
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
