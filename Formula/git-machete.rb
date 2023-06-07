class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.4.tar.gz"
  sha256 "d9837be828d4fdb123ae9c6723654cd0dc5a8ee70930089d6c9f1a57e1622253"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc21e23a54fac63862c50fc73e211760ea80ade0f0c35bf7858e13f6d972fd75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc21e23a54fac63862c50fc73e211760ea80ade0f0c35bf7858e13f6d972fd75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc21e23a54fac63862c50fc73e211760ea80ade0f0c35bf7858e13f6d972fd75"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e3fecf6e12de77a084deee198ced8a95fc4ef11337acf509e2f4891f0a414e"
    sha256 cellar: :any_skip_relocation, monterey:       "d6e3fecf6e12de77a084deee198ced8a95fc4ef11337acf509e2f4891f0a414e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6e3fecf6e12de77a084deee198ced8a95fc4ef11337acf509e2f4891f0a414e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c113a26a444754d4dc3ce53b2f38421b832f32c32a1ba62910b5324f608de875"
  end

  depends_on "python@3.11"

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
