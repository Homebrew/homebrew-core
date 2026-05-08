class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.13.0.tgz"
  sha256 "bcd2680e90f494a37b12c2d45846d096743669e6c298bd75666d5d988f23c058"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fe82b47ff3a73b7f5480ee86c7b228029a047da9bc5e72d6638b90fec7cd431"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end
