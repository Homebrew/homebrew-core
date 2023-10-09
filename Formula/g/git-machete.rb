class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.18.3.tar.gz"
  sha256 "b15b9abae64595aee80687ef5a76304a4eae10cd36499b95b7308777594484df"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2110a6ac3603f52433573feb7ee98064257723a4a085f677adf053d84ef71a6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3762d7b3b175c08e509badd35f1e422d1e07a59e6caaf9149c65a278af3778d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4b00707e4f0c341f0d8c9273baedab60e66d518f2ad525a9c20fa88572aadf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "394c87b6243e24b61e7ede4470bdd5ab79caab07e40eb8d261e26f7c90048aae"
    sha256 cellar: :any_skip_relocation, ventura:        "da918966414f7ed27de13664dad334dcb8703bd958bbdb992fd2c9fddc833dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "76e290403af47c0483d92663a56bcadc88da997f2bb2a765048f67b509d8301f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f56de3a1ce0345c589114dbc31db9315a3c3401bf2dbdd83526877e16634ef30"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

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
