class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.6.tar.gz"
  sha256 "679fcc96bc5073ce222971fff59c8372025328726713cb86bd33d9c7450cef6f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe4f2d87fcf25ae42232d3a6ebe6523f08a59a9c7d3eae45568e29387cc751ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe4f2d87fcf25ae42232d3a6ebe6523f08a59a9c7d3eae45568e29387cc751ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe4f2d87fcf25ae42232d3a6ebe6523f08a59a9c7d3eae45568e29387cc751ef"
    sha256 cellar: :any_skip_relocation, ventura:        "45693b7a6a802d6a7888c9a3a81226bc43ea9a9b0ef40cc48a205832dbf245c7"
    sha256 cellar: :any_skip_relocation, monterey:       "45693b7a6a802d6a7888c9a3a81226bc43ea9a9b0ef40cc48a205832dbf245c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "45693b7a6a802d6a7888c9a3a81226bc43ea9a9b0ef40cc48a205832dbf245c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8cb5ce1d4ed1c82ed9a86d2c76c7428edb68e32477c698df9332c92e15a68e"
  end

  depends_on "python@3.11"

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
