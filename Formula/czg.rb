require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.3.11.tgz"
  sha256 "eec5e65e8777073ed61c364f46d9569aea2b2a55f7bd2236b2ac4f8df39bee6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e04cb0b3787abd852a890d5d6ebbe8758dc975cedf21d91f88d9498808c8736b"
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
