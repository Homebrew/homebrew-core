class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.11.1.tgz"
  sha256 "1a7514a25f6568762cbda7a4a8c688682b96981013a1f898dc07dce3df29f0bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dcbba0e4be5749e5fcb7da0e4db1e544fb4a323d98efd0946bb24d5c0b06b149"
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
