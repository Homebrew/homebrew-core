class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.1.tar.gz"
  sha256 "011540451bf18193a234b618e117ce4cfe95bfc9381afb8a659affbaedfb7e81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a286e3f52c03a026d5b95b86e1ff31df41f9f87a3630c9351ee3384feabf443"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a286e3f52c03a026d5b95b86e1ff31df41f9f87a3630c9351ee3384feabf443"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a286e3f52c03a026d5b95b86e1ff31df41f9f87a3630c9351ee3384feabf443"
    sha256 cellar: :any_skip_relocation, ventura:        "3ac81d5403c162306b3992f768df651ec1f1086ab81248d5c8b26cee5b193f99"
    sha256 cellar: :any_skip_relocation, monterey:       "3ac81d5403c162306b3992f768df651ec1f1086ab81248d5c8b26cee5b193f99"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ac81d5403c162306b3992f768df651ec1f1086ab81248d5c8b26cee5b193f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a3494c7a8b4a5aeaa47f7ba2f9750e945513e0e8ae88b0e30e0d3cb096af29b"
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
