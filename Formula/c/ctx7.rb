class Ctx7 < Formula
  desc "Manage AI coding skills and documentation context"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/ctx7/-/ctx7-0.5.4.tgz"
  sha256 "c8cabd84d53737dedb7b0f73d3628033b5f45933776ab313390d39642293c3d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e13592bb2c6c27f2f1f47dadfc14dc238a7b592994e4a6f59f9a15507505433"
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
