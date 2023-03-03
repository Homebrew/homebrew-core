class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.16.0.tar.gz"
  sha256 "04787928e5b097afef88823711e675fdf2d0933823f65e4561ded0710e80a721"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "061d6d5c3171066a85501897ce652652e39521ea4ac09455547a50108d065425"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "061d6d5c3171066a85501897ce652652e39521ea4ac09455547a50108d065425"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "061d6d5c3171066a85501897ce652652e39521ea4ac09455547a50108d065425"
    sha256 cellar: :any_skip_relocation, ventura:        "64c97f4f8c8db9dbce5e474a193bc52b72d2047ac336b707f0da91e6f971bed2"
    sha256 cellar: :any_skip_relocation, monterey:       "64c97f4f8c8db9dbce5e474a193bc52b72d2047ac336b707f0da91e6f971bed2"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c97f4f8c8db9dbce5e474a193bc52b72d2047ac336b707f0da91e6f971bed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d728823e50e6ff642f0ed1f03af0dcc81faadb39aed22fe1039e9469de5f295c"
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
