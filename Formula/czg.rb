require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://cz-git.qbenben.com/cli/"
  url "https://registry.npmjs.org/czg/-/czg-1.3.8.tgz"
  sha256 "c1994df8ff1829953b31e071101a8eea8fa5065fb95842afe33440a415bf6b93"
  license "MIT"
  head "https://github.com/Zhengqbbb/cz-git.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("#{bin}/czg 2>&1", 1)
  end
end
