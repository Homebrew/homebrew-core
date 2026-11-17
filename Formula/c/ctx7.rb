class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.12.1.tgz"
  sha256 "8a4bf14ec99d698a8bdb88265db244e1d1dd4553be1b0a6d6d3c0e79224afd89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8f6af637db7d9ab38d1e3ae3a85b580544d9d2182f5f9d3902bbd48b7ca4bbd"
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
