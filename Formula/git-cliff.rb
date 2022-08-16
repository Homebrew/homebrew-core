class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "0d7390ff23ee16efc93e8d7f2061cfa16c079ed609bcee045e67590c62eccd07"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a69965279d02cb7b034f9f782c59d19a9884285f7f8b80ffdf478bc43e68c8c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9ef6e5cedd40eb18b86d69320594863c2a20b024f8f078bfa74db59e6138edf"
    sha256 cellar: :any_skip_relocation, monterey:       "cb5f0a05fa50c82aa902fbefbe6adb2f113a8c022818020666ae4b53a77dec9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "939a74749557429fa807e25d1fe202207f02cbbce0ad4a994df8027d7772f937"
    sha256 cellar: :any_skip_relocation, catalina:       "748a676d6263eb67ca75099909553f3da38a4648df57b969c274674ed5d94661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3bc2ba7648e2fd6e8cfba06c4a539d6981a4654322308acb152d1da55378f59"
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
