class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://git-quick-stats.sh/"
  url "https://github.com/git-quick-stats/git-quick-stats/archive/refs/tags/2.9.0.tar.gz"
  sha256 "b1e88b23c6a1e161e12dbf6978f5d57f0be2f4ff7308032ceca479aeb54e65be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d151f427f68797d73c37feb74a205e9f13e483307e83313075a7bbf4ec605153"
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
    ENV["TERM"] = "xterm"

    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?

    system "git", "init", "--initial-branch=main"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match(/^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1))
  end
end
