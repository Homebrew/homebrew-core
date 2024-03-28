class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.24.2.tar.gz"
  sha256 "5cd9ef786d295b30940677c4b0cc183e2c5196596023ad91ecb84ddcc85fdc4b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e855de81a2fb5d723a29eb50506d48ff0a17c0fe7b3e2fefc14d2a13adc93bbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e855de81a2fb5d723a29eb50506d48ff0a17c0fe7b3e2fefc14d2a13adc93bbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e855de81a2fb5d723a29eb50506d48ff0a17c0fe7b3e2fefc14d2a13adc93bbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4c51d4a81a6ab3cee5aebff1db2d16476ceb05f39c61ab6927a8e56a2c613b3"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c51d4a81a6ab3cee5aebff1db2d16476ceb05f39c61ab6927a8e56a2c613b3"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c51d4a81a6ab3cee5aebff1db2d16476ceb05f39c61ab6927a8e56a2c613b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33b442b21ee06cffff73abbdc9222f5cbcec3516aeab3518ad0bcff562ae568"
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
