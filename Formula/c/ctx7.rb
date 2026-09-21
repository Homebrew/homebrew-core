class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.11.tgz"
  sha256 "05068b5b7593a67af4bb3ed4f458f0d56d2b92b9d01c1c40abe65376556fe3b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab95c43e13ff4aced3a86d2e612cc30e934b206bb773cd14a80dfd36b68b60cc"
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
