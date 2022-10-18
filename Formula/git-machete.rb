class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.12.5.tar.gz"
  sha256 "07d930ddb5c946d45c37e13882b2fefdeecbea935d31b3512cc482c64beaf187"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce8860fc70e8c263d28c66a9313d9302c6c1acce4ba73133f307433faf7bbe48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce8860fc70e8c263d28c66a9313d9302c6c1acce4ba73133f307433faf7bbe48"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd8761adf5d91551e6f5b5b13e3e4e997a501ae97c390da19f44955104b8abe"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd8761adf5d91551e6f5b5b13e3e4e997a501ae97c390da19f44955104b8abe"
    sha256 cellar: :any_skip_relocation, catalina:       "2cd8761adf5d91551e6f5b5b13e3e4e997a501ae97c390da19f44955104b8abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6896a5df7bea5b1a3285107f18ef7f2672e2838bb7846a684ff5dc134655b32"
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
