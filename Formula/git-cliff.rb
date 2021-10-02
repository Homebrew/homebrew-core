class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/v0.4.0.tar.gz"
  sha256 "a02e75d49c10103c9b07169e264479e1b6ca2a5387594057be6dd6953dd2bbe6"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e5181292cbff03ec772baf3ad8cf54d9e65491e25f6170687b10e1b39ea0cbc"
    sha256 cellar: :any_skip_relocation, big_sur:       "9303855b2c052e0756f9cee2622a3531308dbfb7d4f369fa6b0f8d53d307ebe9"
    sha256 cellar: :any_skip_relocation, catalina:      "c434adedbb1683abbf2ec4c4d1a3d1fae793a02fcc8e6bda766d13a56c64095a"
    sha256 cellar: :any_skip_relocation, mojave:        "12e9bb1e9e4e257d3d1bccbf6ec2a52c44226d2f4cb3f798c6df0d48e27f8f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9de1bbfb8b9b8e07d60825f1e61586e0247059283b7cb607f7a693cdb64a97"
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
