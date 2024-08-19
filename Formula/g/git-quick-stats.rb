class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/refs/tags/2.5.6.tar.gz"
  sha256 "ddb2552cfbf605bd934c0d570ca2d0e77bd32f8d1ff706af1d3ac96dcf612ab7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc53ce17388a8bbc06357cfc7ca2c5d375ece86d6566a2cade7cacaafe28bab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c02697c23bfc161e378c6dbbeadbbcc3881b58a729e9a513ad49f6dcb8b04feb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f0011f622daf031811c012c93896541235fa0db3f11d3aba5d733753c0a628"
    sha256 cellar: :any_skip_relocation, sonoma:         "34766cdb92cbb90196cf07a85632c47db1b12b332010b087af61b7d6e3a3f6d6"
    sha256 cellar: :any_skip_relocation, ventura:        "79f5aa80d8a13fd3b47300afc26d8736f88f19021b273808e86039b815d78892"
    sha256 cellar: :any_skip_relocation, monterey:       "9c426ad54bd1e02239dfdc74138d8ab6be28f4e711bd18c0c41dfc450f9eb238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04673d84aee73f1b79dbb7f8a49b6b8099b7cc6ef57706e557db23278f39c318"
  end

  on_macos do
    depends_on "coreutils"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
    man1.install "git-quick-stats.1"
  end

  test do
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?

    system "git", "init", "--initial-branch=master"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match(/^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1))
  end
end
