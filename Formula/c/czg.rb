class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.11.2.tgz"
  sha256 "f889ac460aa0d0eed65fc550569bfed548e5f5592e7d804162ed2caf44f6942e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43b0f897d177111d128b04cc15e26eccd16edc181ccc57d7240e7b76f05b1cd0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end
