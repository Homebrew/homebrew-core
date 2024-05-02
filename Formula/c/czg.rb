require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.9.1.tgz"
  sha256 "b84e02dd3639ad5d5c16b283e1a489bcb5a33bd3359ceb1d6db2ed2eb00a18da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "49ce4bfcecd606fc4433d4d6610b4e3159115bc3af65658e07f7c13f661339ab"
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
