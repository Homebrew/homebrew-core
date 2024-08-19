class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.9.4.tgz"
  sha256 "d005cdff971561e70fe64d615ab67e60d5eba0e8f9dd8994fa22b54f861f9b47"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c75647262ed4bed88908c8e95f39b01e2e4e65eab8702e1b162d9148ed1eaa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c75647262ed4bed88908c8e95f39b01e2e4e65eab8702e1b162d9148ed1eaa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c75647262ed4bed88908c8e95f39b01e2e4e65eab8702e1b162d9148ed1eaa2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c75647262ed4bed88908c8e95f39b01e2e4e65eab8702e1b162d9148ed1eaa2"
    sha256 cellar: :any_skip_relocation, ventura:        "6c75647262ed4bed88908c8e95f39b01e2e4e65eab8702e1b162d9148ed1eaa2"
    sha256 cellar: :any_skip_relocation, monterey:       "6c75647262ed4bed88908c8e95f39b01e2e4e65eab8702e1b162d9148ed1eaa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d30fbdd434fd931ce152e3e473748937cd35061e1159b016ff05d882fbf6c74"
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
