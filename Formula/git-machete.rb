class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.14.2.tar.gz"
  sha256 "b224968f02b48e479353ebeaed64247f65d90fa2ad8c5b4c690d1c05fa22f4fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "468c6cad158a021c312630b8f3e9fdd281f90a9c73f6ea4b62971c9aab4d5eb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "468c6cad158a021c312630b8f3e9fdd281f90a9c73f6ea4b62971c9aab4d5eb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "468c6cad158a021c312630b8f3e9fdd281f90a9c73f6ea4b62971c9aab4d5eb6"
    sha256 cellar: :any_skip_relocation, ventura:        "bd45a2ed150e3d6de27b6e29e087e6f78e65f5bd5eea5ac7291f2b7932b44ed7"
    sha256 cellar: :any_skip_relocation, monterey:       "bd45a2ed150e3d6de27b6e29e087e6f78e65f5bd5eea5ac7291f2b7932b44ed7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd45a2ed150e3d6de27b6e29e087e6f78e65f5bd5eea5ac7291f2b7932b44ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a964853776c4534078a080c6eca9618abf0d4020766e92ef9d1cb0549aebba4"
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
