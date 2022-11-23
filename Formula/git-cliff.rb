class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c77b7b38edae80b3a66c96f15d0bc3eaaa0bc55e1d3fbc8187c55070306188c1"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "520d602d1ebe507fd6af954eea3fce839da952ca62efa173eb8d03a254b9cffa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a42d519e73b38680943ac5ad8a857ca1bb528f548f3acd0f72a0a96e079cce52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fcc0775ca9c464e3911ed5c5e37f3556c855a76f89e0df25644f6b3d92b327a"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e8b8b1244bc2f30e75d893c5a50206bbbb1b025981d2c9a8dc87dd421c79e7"
    sha256 cellar: :any_skip_relocation, monterey:       "4c3609864b7adb01b483c23a5a299048f72b9635b21dc4b593ce80e0720e435c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c39b13006dac7ad2ecb330165c8c9230c117495455202467559d47cf2e3007cf"
    sha256 cellar: :any_skip_relocation, catalina:       "c60405d0c481be31f6291c9831aca690fc90f1baf61532fb9e894299b358c36d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eff6f3d0bec0970501db19f74b3d0b35a70562859f8e19019c5488549a44ab8"
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
