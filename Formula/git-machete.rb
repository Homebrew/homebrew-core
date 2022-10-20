class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.12.5.tar.gz"
  sha256 "07d930ddb5c946d45c37e13882b2fefdeecbea935d31b3512cc482c64beaf187"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3b878fe8f3b5da3a8771e54e720661c9c34997125f904ee2f5c7a5438dca56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb3b878fe8f3b5da3a8771e54e720661c9c34997125f904ee2f5c7a5438dca56"
    sha256 cellar: :any_skip_relocation, monterey:       "2e8a826efbca900e10490be313bcf792b6411381508d0e5ab1e493cc93d50ee7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e8a826efbca900e10490be313bcf792b6411381508d0e5ab1e493cc93d50ee7"
    sha256 cellar: :any_skip_relocation, catalina:       "2e8a826efbca900e10490be313bcf792b6411381508d0e5ab1e493cc93d50ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cce4b60623d65a55e9363e1e6e8d05be8a76bc4faca929e9bf3c8fd9c70aa00"
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
