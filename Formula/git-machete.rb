class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.12.2.tar.gz"
  sha256 "26e4db71a5bf21ba335e82d5e37415bf32e30c1a592493eb16533ed6a31c34bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba320a4c303b5ca9ed4303bdf73201cf5cc52a4304f1ec1f25848a5bd4c91c42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba320a4c303b5ca9ed4303bdf73201cf5cc52a4304f1ec1f25848a5bd4c91c42"
    sha256 cellar: :any_skip_relocation, monterey:       "e590dd298122757fbd9fcf3986f768d67ff9378734503eecb3318c8e1a6b041c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e590dd298122757fbd9fcf3986f768d67ff9378734503eecb3318c8e1a6b041c"
    sha256 cellar: :any_skip_relocation, catalina:       "e590dd298122757fbd9fcf3986f768d67ff9378734503eecb3318c8e1a6b041c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48f2fddec300b1fc1267ce159669436207f5f3cf49791c0322e012573c09a6b9"
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
