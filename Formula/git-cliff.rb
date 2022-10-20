class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "86ed2b9e84d062a880f431aec2d7550cedfab4232e76af4398f4cc3b3a487cb9"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9439d7732cfbe058b31a5185726be7570bf91ac25d679df48e15e44ba695a246"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04655ae29ff3778d05b85f66cca011f5226880f4cd35dd34750c6685daf48445"
    sha256 cellar: :any_skip_relocation, monterey:       "5b73b99a8c598bdf386e42a0ea36a578f4778ecee7669cafce87e5ee0f0175f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e155cbf1ce8c31d14ad78cee11f4b9ed9d5a1be8fc328b0b53bd60dc6b07e16a"
    sha256 cellar: :any_skip_relocation, catalina:       "212a92fada95d6f2f89b4e834695dffa48a3e46af5f1a8e3043a054d58e84a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd82eafe1060133ace2514b7e4dd5c6d2033499b3a2d0b5dfb589bd71e28d9f5"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")
  end
end
