class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.3.tgz"
  sha256 "5e20dd725ce0f5646ff0f49e66387aab519a07cbc9dbde670ff1d4d4505d3ac9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec026deb33d17991ccb0f12e798aab5dd733911fce12d31088a0c76fc39f53e8"
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
