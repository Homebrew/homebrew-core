class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.16.1.tar.gz"
  sha256 "9688e810c4a75e75aad0886a4180ac78a5c56afe06878f6d21a9cf8fcf8acf9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17b154497693ca5e9f1f005b5bea590c6ff029410ae73769b875a271266acbc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17b154497693ca5e9f1f005b5bea590c6ff029410ae73769b875a271266acbc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "17b154497693ca5e9f1f005b5bea590c6ff029410ae73769b875a271266acbc4"
    sha256 cellar: :any_skip_relocation, ventura:        "2e61c121a39978953ea51228c8b9c4f1141d3c4991f85df15de024c8340272a8"
    sha256 cellar: :any_skip_relocation, monterey:       "2e61c121a39978953ea51228c8b9c4f1141d3c4991f85df15de024c8340272a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e61c121a39978953ea51228c8b9c4f1141d3c4991f85df15de024c8340272a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec51354a32a0030bd6c579415a12d511da56966691b06e4fc54dba9a1c5670a6"
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
