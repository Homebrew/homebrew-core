class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.18.1.tar.gz"
  sha256 "03cb26e9d8a7aa90002e4cc336088b8e40312a9c49eed9eb31258baf7b964861"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f714d96815bc7febcae25dd278ed198274967a16577593eec5b81c65fd7808"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f886d876d8e94862a26ab9d7c03c26bc23b2cfb95b47641cccfe312b760eba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f33fd3f010b5d25f678132acdb3b066faf9a791be30b901fdcf2314cfee88dc3"
    sha256 cellar: :any_skip_relocation, ventura:        "f8a32845d0aa14a4c687e40b90d44f7238b2119b37c093b3cd97e349317617a6"
    sha256 cellar: :any_skip_relocation, monterey:       "3798cc7b3f9733770f9574986f26f7359de52f3e8d13c571e9b07a0a253b59ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d9236009b4ef6884847c7c7afaaeca85eb7948aa17f36ab67893a1e21339b9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "857d2f8e8faa7920686a7d4e0090c2d82d3eec2d327b0032a8e4ce69df1f6a7a"
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
