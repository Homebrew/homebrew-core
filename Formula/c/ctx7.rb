class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.4.1.tgz"
  sha256 "7bf3b6be28f206d3c6cfa0e74d0256e3021a1a2cf5e08a567a4a5da2da2605a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99a8c65c4abf40d11ab383b16decef26be15b9a28c6df7f3a9d0fcc0fdc3e7fe"
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
