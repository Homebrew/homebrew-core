class GitMachete < Formula
  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.23.1.tar.gz"
  sha256 "72826eb4ab0b082b1e83b4d8f8d1982d35ae60e375d2ff6c67b407761c7fa202"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45e51254ef03de9797475fe41d80bb1e6a9528dda98c8bdfa7cf3929c9e0cb13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3c542b82b0a841395c6530c957e3016a0e05a5ff12a44d65a6140e943fde7ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a876e00bbb3a0b41417d0df7a29d5e56e65f0023312928cb1907185d60d30701"
    sha256 cellar: :any_skip_relocation, sonoma:         "f4883e82f112528b7ee8fbfba2a341cc9e64d069b04175cc26879834836ef04c"
    sha256 cellar: :any_skip_relocation, ventura:        "60c6c0c69b062ea55b85f7848365c8c123f83c9ebf9d67040d5feb334abb981c"
    sha256 cellar: :any_skip_relocation, monterey:       "924895ed0b640091e96f385c8298e1211b8bc0e30e08ddd6752610d7535f8502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9914faa355def03ae7046deaa78283f0764b9b8fc6476c1592c7974e5566802c"
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
