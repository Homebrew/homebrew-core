class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-13.1.2.tgz"
  sha256 "62e6c15eb81bedc7ff7d8c7cb0c85486e565c6d44f66f91e59af99b571910cce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50643c261014d52089137b92323a9b5993a2e1c20b7b4a96617d46e275523cb0"
  end

  depends_on "node"

  conflicts_with "bash-snippets", because: "both install `pwned` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pwned --version")

    assert_match "Oh no — pwned", shell_output("#{bin}/pwned pw homebrew 2>&1")
  end
end
