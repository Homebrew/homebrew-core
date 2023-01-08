class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "6a59923f76a636094c7ae6849dcac444e815af4c876745ae251a499e99b58acb"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1741f6e597cc8405caac261c7c4bd46ddb50ba628e34c8afcba9ee26af9a741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26de2d156fffc3e1b411533be30f5eb89974260f0874d169de91cc4c81943516"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cff3a8df9fc05dc9fe6aedde72d456e5a7f39477287c9bbc755b58f116061d2"
    sha256 cellar: :any_skip_relocation, ventura:        "e33adc758d105fe69e0812846cee86f53d61f7e657da3cacaeea1dbd29d1916a"
    sha256 cellar: :any_skip_relocation, monterey:       "b4606b9c79cd304635d4105e151efd454d54811fa039ffb2c7f3a619818188fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "5475d8065a4a34b2074d5f4f05b1616153680225e85fc271a0374578a20c70d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8f5da6008832f634cce1381b8773d2b7ce8122c0e61b4dfee80e48d04dee319"
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
