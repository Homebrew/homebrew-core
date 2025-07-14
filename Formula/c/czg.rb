class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.12.0.tgz"
  sha256 "3cddc98d072707ab6f40d65057b40bb7b57ee7f7cd00cea572f2c8a4ccd60a0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c6a8d80823d004678e69bc17eaa306e0f93dae326b93e0a5d0456fbcc8d35cc"
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
