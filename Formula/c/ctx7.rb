class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.12.2.tgz"
  sha256 "04c5cb6099d1406a80c1ecfb7ef1c56b8f984db442f498b24441e5e722b1f98a"
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
