class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.12.3.tar.gz"
  sha256 "9020ff06b1110ad7b8d92ea43f523bdba25e63785c2e9cd0aa65385965e65efe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf2209738a9be96fd9b04ca326438896b587ad4a8a8326ddea229eb124ba6fe4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf2209738a9be96fd9b04ca326438896b587ad4a8a8326ddea229eb124ba6fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "09a5a0e6af1d764f0e4ea109930c448cf4aafc88d66d29c17634e7fd6c543070"
    sha256 cellar: :any_skip_relocation, big_sur:        "09a5a0e6af1d764f0e4ea109930c448cf4aafc88d66d29c17634e7fd6c543070"
    sha256 cellar: :any_skip_relocation, catalina:       "09a5a0e6af1d764f0e4ea109930c448cf4aafc88d66d29c17634e7fd6c543070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73603bf9529090265a0630b7416cda51885c2845a6f3e6b702b9bbf06858c4b0"
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
