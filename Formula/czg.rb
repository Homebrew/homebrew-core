require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.4.1.tgz"
  sha256 "23234a955dbc92d4ff852c5a62774922537edc77924d0071d1f0e2b1dc6987b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "daa2d6d7645307d6f8e9bb0775dbb50053fcd560b33fe0f9eba54f4de0ac41af"
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
