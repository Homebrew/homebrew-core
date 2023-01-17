class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.14.3.tar.gz"
  sha256 "425ceac58443097ec06ba93063e10d7ba267a33b7180754421f9facae4e0419d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb2050b66853161aa9c892285f6f23ccf3199c8fed9b404a1eb311d2de88668a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb2050b66853161aa9c892285f6f23ccf3199c8fed9b404a1eb311d2de88668a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb2050b66853161aa9c892285f6f23ccf3199c8fed9b404a1eb311d2de88668a"
    sha256 cellar: :any_skip_relocation, ventura:        "38420dd2842670c2f35b381cfa0fc2b30a995151129ea404f1ec097e513dc286"
    sha256 cellar: :any_skip_relocation, monterey:       "38420dd2842670c2f35b381cfa0fc2b30a995151129ea404f1ec097e513dc286"
    sha256 cellar: :any_skip_relocation, big_sur:        "38420dd2842670c2f35b381cfa0fc2b30a995151129ea404f1ec097e513dc286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3fd219469ec7db2b2f716a069c8b4fb26c4c5fd9074dfdcdb684edde5edff5"
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
