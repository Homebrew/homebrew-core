class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/74/de/867d9261bf9b9b8564da3cd2a13f16c599dbdb404bab65c5a3da0d0a852d/git_machete-3.40.1.tar.gz"
  sha256 "cd854237aca15493b59361d0357baaf8fb65ccd79728f1fe1807d7006f61d03f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1e45a080fa2e791a624fac23f60c42b46c94346bd895f1a05ce9fa4e26ee6a6"
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
