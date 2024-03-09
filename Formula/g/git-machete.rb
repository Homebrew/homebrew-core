class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/f3/fc/5799f4a6f424a86c8607c195dc6c9066f4fca9050e377f6fe46b9cc654ad/git-machete-3.24.1.tar.gz"
  sha256 "31f06ba0a0412647fd4977bca487e100820a72cca473869082314f20276802bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b82c4245a8ee898c67d3ab3082f701beea5f623db294d1b928526a326f53c0bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b82c4245a8ee898c67d3ab3082f701beea5f623db294d1b928526a326f53c0bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b82c4245a8ee898c67d3ab3082f701beea5f623db294d1b928526a326f53c0bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "faf104fdb8d8900bb8aa578c815df83376f183d408cc4e53b7779bdce6774144"
    sha256 cellar: :any_skip_relocation, ventura:        "faf104fdb8d8900bb8aa578c815df83376f183d408cc4e53b7779bdce6774144"
    sha256 cellar: :any_skip_relocation, monterey:       "faf104fdb8d8900bb8aa578c815df83376f183d408cc4e53b7779bdce6774144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4657d5f1705972cb4b6498f66bea2411524fc39a4f669fa601173a31d84139fb"
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
