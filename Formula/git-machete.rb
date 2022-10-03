class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.12.1.tar.gz"
  sha256 "1c9d2e8802e9e41cd7bb3d52ea650e71b925379c30c182db706bdefb7236a16d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd55a44e0c7cc77cbc52208b1cdd29bba2724982f41847838a8281840dee78b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd55a44e0c7cc77cbc52208b1cdd29bba2724982f41847838a8281840dee78b2"
    sha256 cellar: :any_skip_relocation, monterey:       "8630c377f2c0dc0e4175cd809e2a7d227934fd51e9c6cd60efa854a2f5d44d1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8630c377f2c0dc0e4175cd809e2a7d227934fd51e9c6cd60efa854a2f5d44d1c"
    sha256 cellar: :any_skip_relocation, catalina:       "8630c377f2c0dc0e4175cd809e2a7d227934fd51e9c6cd60efa854a2f5d44d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c9679680e8107f71b53a460cd884d8668c64f83b5b65f4bf72b72df8ccacc36"
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
