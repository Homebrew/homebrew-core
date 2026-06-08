class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/aa/ab/a558a320d48b12b6f8215745863fae5a927c179e2cc5fedede5a8826c566/git_machete-3.42.0.tar.gz"
  sha256 "481ee1984f193ce5718b7323b81881ec91c3ee2028b7c90bf9efe91d4241c7ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19e0f184e8f4edcef49b62c5720f628d34bcb7ec5f5acab5b3840090ad1bfa22"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

    bash_completion.install "completion/git-machete.completion.bash" => "git-machete"
    zsh_completion.install "completion/git-machete.completion.zsh" => "_git-machete"
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
