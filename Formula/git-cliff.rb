class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/v0.4.0.tar.gz"
  sha256 "a02e75d49c10103c9b07169e264479e1b6ca2a5387594057be6dd6953dd2bbe6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "23f8e05201cbd29e64aeb5a488b18a0d1db971907797c4a9227c18466665e6d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "542b391a9b353fe44c6670cc30372379fd7dd82f189d8983e12d9283b506b22c"
    sha256 cellar: :any_skip_relocation, catalina:      "9b8e80bcc93d8092e80b2f9816f0398f1e52377c8ca7edd881c5a9ff431627d0"
    sha256 cellar: :any_skip_relocation, mojave:        "3a0d7242cabfee1adf2ac47e902734bbcda6354114379a13c7a6adb6a3ccbf36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b0a1f5b10aeb647ceecebdde689e1eeec055a34a75a4f6b7f111b187db841e"
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
