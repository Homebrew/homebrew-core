class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-13.0.0.tgz"
  sha256 "7fc19a4a01c0d25356b7f700583fdfce1963f3942312cfd33e32b225ab7f2e91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85fef6c273b01f0dbbccd45e0b76008832fddbdfe6fdfd402e672eb751bb208c"
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
