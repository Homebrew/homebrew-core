class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/d4/4a/fc3f5a08a8cf2354472402f49cc7b9c7a3f27ce6213cb3462abffaaea423/git_machete-3.26.0.tar.gz"
  sha256 "7623d0c5ed10bff16471bca2d5879d63f0a3d347b348a60a6570ddcb60337cb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f143cf954e402966e1adb6b0bf6e52a00928a781a254581bcdb4125365b89166"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb73f3bfe58cfe3542da5e289ce7e5f2933f26a7505fa9c04958412dafd16e2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a596fcbfeaf2b1df32385a32a23b270eec5f28be9db99b681506b0fcaba8eea"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed3d9af488640caacd31d05bb3482f4e2ed734007ad7df3a549fa4696fb99847"
    sha256 cellar: :any_skip_relocation, ventura:        "fae38193a1e32f48e8ecaca3cf55fae0797bc8f4c0538837eb5191b582599140"
    sha256 cellar: :any_skip_relocation, monterey:       "01c25d2685c4793867ac167b8e2de3902805f3cce4f2ea792b69a711fcf17eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03443e3dcfbbb51abcbfc5087dee265077a1230320a709f2dbe7241c4d649919"
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
