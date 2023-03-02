require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.5.1.tgz"
  sha256 "6c27f34176049cfc560c8bad6b5644dd10795882db0d9adb4d1522bb9056c228"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87377ed2d653acd1e10abed8e868ed04b0d25acb2c4af0b06ad4b9e0d3f887c5"
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
