class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.14.1.tar.gz"
  sha256 "7ed30ee27f5a2d6b79120b18c3e817518601a10e429a764cf21eeb8d1ecdc490"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4049f84021b6414a2f2c97accefd3432d413d3fa169c6712eb5690f3177a111b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4049f84021b6414a2f2c97accefd3432d413d3fa169c6712eb5690f3177a111b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4049f84021b6414a2f2c97accefd3432d413d3fa169c6712eb5690f3177a111b"
    sha256 cellar: :any_skip_relocation, ventura:        "72d3e9ba47c19d487b7899e111902476f993ee1d498d52fa32f51e6509104d12"
    sha256 cellar: :any_skip_relocation, monterey:       "72d3e9ba47c19d487b7899e111902476f993ee1d498d52fa32f51e6509104d12"
    sha256 cellar: :any_skip_relocation, big_sur:        "72d3e9ba47c19d487b7899e111902476f993ee1d498d52fa32f51e6509104d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "908538deb8bde139c94ac1b873b779bbad15bede9a2bdf62938eef012e0d626c"
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
