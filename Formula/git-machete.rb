class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.15.0.tar.gz"
  sha256 "fd8ebcc60e27a9f01ddd84ad25ef30ac04012e28271645322f6d436af5d01525"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d37b39ef8351e777e3801558a973a6aa14e4f1c1f12ad5fb42055840c09a4de0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d37b39ef8351e777e3801558a973a6aa14e4f1c1f12ad5fb42055840c09a4de0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d37b39ef8351e777e3801558a973a6aa14e4f1c1f12ad5fb42055840c09a4de0"
    sha256 cellar: :any_skip_relocation, ventura:        "a4bbf70a9703834f86fc4ec32faa477c6405f5291934eccee29420a89e0d74e1"
    sha256 cellar: :any_skip_relocation, monterey:       "a4bbf70a9703834f86fc4ec32faa477c6405f5291934eccee29420a89e0d74e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4bbf70a9703834f86fc4ec32faa477c6405f5291934eccee29420a89e0d74e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7493b7aa875b548d4e0e5264f19ca309659b401654ca71c6cdfb58ad2e19604f"
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
