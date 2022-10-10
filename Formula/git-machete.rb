class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.12.4.tar.gz"
  sha256 "dfebd62944838c6c2404ed8967f9cf8999577936dd7dbd296f3793b85c306a76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08e6b4fc370891edb4628da00f04f276a732a14fce6eaba0af40ced6496da786"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08e6b4fc370891edb4628da00f04f276a732a14fce6eaba0af40ced6496da786"
    sha256 cellar: :any_skip_relocation, monterey:       "a55a144c99cf36cc41b08e352ea0359514cf84733e44940b8ac49cc45349c45c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a55a144c99cf36cc41b08e352ea0359514cf84733e44940b8ac49cc45349c45c"
    sha256 cellar: :any_skip_relocation, catalina:       "a55a144c99cf36cc41b08e352ea0359514cf84733e44940b8ac49cc45349c45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebe42b31c0921c487926b29315d125d3acfb103950532a8c22757aeca10f4e57"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end
