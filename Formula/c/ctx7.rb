class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.9.0.tgz"
  sha256 "2e3e86c9a5f55c04d9812d5cd1d143a29a33f456037bc585e7724a74bf0301fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1404cb2cab2ddf497fffa1b827ec0c6097276d95cf4ff47038257675d69b0ee"
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
