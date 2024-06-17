require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.9.3.tgz"
  sha256 "c324e29a7ff02a0857987ad7f1f8601588cdf81ff792715f2e133eb653768f80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd7fb5e43ef603f5cef716e5ac20a1501a8bec34f1e8b0fb847b29ba73f53b59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd7fb5e43ef603f5cef716e5ac20a1501a8bec34f1e8b0fb847b29ba73f53b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd7fb5e43ef603f5cef716e5ac20a1501a8bec34f1e8b0fb847b29ba73f53b59"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd7fb5e43ef603f5cef716e5ac20a1501a8bec34f1e8b0fb847b29ba73f53b59"
    sha256 cellar: :any_skip_relocation, ventura:        "bd7fb5e43ef603f5cef716e5ac20a1501a8bec34f1e8b0fb847b29ba73f53b59"
    sha256 cellar: :any_skip_relocation, monterey:       "bd7fb5e43ef603f5cef716e5ac20a1501a8bec34f1e8b0fb847b29ba73f53b59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e8aff93d4b3c16511f24a7846851dd694edf1ca21da0a55c1df9a4f4784264"
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
