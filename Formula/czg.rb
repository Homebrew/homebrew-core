require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.3.10.tgz"
  sha256 "618fd190259574880c40b9e00715fc1c30aba98df927951ba9b8c06b61a2bf34"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e29b12c9a2fcb27f1c8bbdcd2a766b353c4ccf971a374e7843ddc4dee1ac5e5d"
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
