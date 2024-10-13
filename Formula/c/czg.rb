class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.10.1.tgz"
  sha256 "e92e718e06d7e46075c52b3768eb2511eadc76855c604d6bb0b51d579935ce1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be41d1971f0154205cbcbf34435638b689e94f9ffdeb8b9f60091c8a7e293218"
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
