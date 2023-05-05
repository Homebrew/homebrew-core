class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.3.tar.gz"
  sha256 "12e998708e16552c476d606ec4964ced34d517d28f8ed2490e13257f09e6eb3a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25985a085dcfc80b1b5dbd83824038ceb26fb0ee4d2efa8af7514de68278f914"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25985a085dcfc80b1b5dbd83824038ceb26fb0ee4d2efa8af7514de68278f914"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25985a085dcfc80b1b5dbd83824038ceb26fb0ee4d2efa8af7514de68278f914"
    sha256 cellar: :any_skip_relocation, ventura:        "7537ac642dbf9ec0df9e164079846709733b908712636974e29a8c1ddf2d6a2e"
    sha256 cellar: :any_skip_relocation, monterey:       "7537ac642dbf9ec0df9e164079846709733b908712636974e29a8c1ddf2d6a2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7537ac642dbf9ec0df9e164079846709733b908712636974e29a8c1ddf2d6a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "340aed6f3fc73db0c18b1244281e373405cb5452bef58ecb158444d528b0b37c"
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
