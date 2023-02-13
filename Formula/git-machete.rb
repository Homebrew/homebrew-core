class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.15.2.tar.gz"
  sha256 "2b385338ce79d7ad811154c987ce5df7815cbe77c03c7ff65fa7faec81192b38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49279a3e2f05ca1dcf8a0478988601ca4814710fc8354983aa0e686cacbba64b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49279a3e2f05ca1dcf8a0478988601ca4814710fc8354983aa0e686cacbba64b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49279a3e2f05ca1dcf8a0478988601ca4814710fc8354983aa0e686cacbba64b"
    sha256 cellar: :any_skip_relocation, ventura:        "37ab461ea67f8ec6cb9f43468cb4b460251ecb526e824348a0063a898baac0e7"
    sha256 cellar: :any_skip_relocation, monterey:       "37ab461ea67f8ec6cb9f43468cb4b460251ecb526e824348a0063a898baac0e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "37ab461ea67f8ec6cb9f43468cb4b460251ecb526e824348a0063a898baac0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3648c24b3f136c8bd5fc80c09503364213fe342c8f23ebc8e01544ee37a12ee"
  end

  depends_on "python@3.11"

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
