class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.10.0.tgz"
  sha256 "c53ca779c658adeb3548a1b23f68af1a864fc14dca00441a0636f78c7cab9547"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "afb952e7568494ae9b3c670c7173883ba72399ba6c76a259539c1b8ff2d10e81"
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
