require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.5.2.tgz"
  sha256 "d4cb49747696eae441f2c1ae2571ce3bf39e02c6a8531a82ddcbcdb0a1d76047"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ac7d90275c86af731147038f3d9a85d1a2485d85ebfb02680eac9d5f5a84984"
  end

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
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end
