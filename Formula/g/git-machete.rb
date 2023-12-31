class GitMachete < Formula
  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.22.0.tar.gz"
  sha256 "6eb9c6a861267c0811e2c8c977c53a1ca16f7d6edf9133d472be68d48c25559c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a533cde09c359e40a5cf3723779cd427408fa7115dd8c2a37d3d75a55c9aef3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4991da2baae3d92b43c33c81adb2c4cb57e742a42ff359e3e7e28c8610c9fe50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "521230b04355cc8dab646a534b2a763dc8ab6cbbff328ab97daa0dca84fad849"
    sha256 cellar: :any_skip_relocation, sonoma:         "eabf1bcb5238812e6989001867f6461204f4243fece6cd9f0f1d2143f3780dda"
    sha256 cellar: :any_skip_relocation, ventura:        "0896e72a25167586f9f0c5515281dbf98b910921e8cc80a4583d12ad25bf8224"
    sha256 cellar: :any_skip_relocation, monterey:       "049880c686b492d365852164963ca9a0d1e57788c58ce562ec42e3d37cce53c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f156fc3d67a401b846511c12f5d55d0bdfc02dc45eaaf48d7c4a5b9b0fbe0b5"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

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
