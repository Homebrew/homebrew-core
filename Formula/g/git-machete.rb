class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.19.0.tar.gz"
  sha256 "1f25d423036970ce32d144c431bdb3a45d330b63f2f5012878ced713139ea735"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7beed74731e81ab61307053c01537d4d9cc41f03f26e44b8fc31e5005c8694c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6eeb8cdc4588ec3a5651b9c96bfdea93561dc9f07cbdf6218d4cfc4c7ac0e7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f763ca4cbaab52bf3b4501caaa35f80356402019ca08e7ad9391ca27d34a586d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f910ad0d0394435b21615129e24e6039cec35f941fe96b970644321a76f94c47"
    sha256 cellar: :any_skip_relocation, ventura:        "1cab3ca28da2852314143d4896105c387ddb69e481a0b44bc92d2c87606f8185"
    sha256 cellar: :any_skip_relocation, monterey:       "5277c98439df5e56120de0981076ebc4e38f2bb70885bb83713e5f76b1cf8789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b6920d38941011f93fc71847efb71bb179a7364c10a542269da2c2dd610510"
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
