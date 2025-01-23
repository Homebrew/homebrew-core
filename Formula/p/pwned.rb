class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-12.1.2.tgz"
  sha256 "cec3ba5e1f552aa46170b70facb5b0c527b08a5810e0db63770bc8360f071fe5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ebd3ad239fc48a2eed418cd390de0919eb63ffc9731ce5317a26cdf046d8845"
  end

  depends_on "node"

  conflicts_with "bash-snippets", because: "both install `pwned` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pwned --version")

    assert_match "Oh no — pwned", shell_output("#{bin}/pwned pw homebrew 2>&1")
  end
end
