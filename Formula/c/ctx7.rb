class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.4.2.tgz"
  sha256 "aaa66ff1061f8e9a914cec5947c5fbc2988ee1b81f8c9bc3c2e4c51a7859cf5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ac67f43125e032146c8bfa5bf61c23b507d2f7977aeb41327a383eee1b332af"
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
