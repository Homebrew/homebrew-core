class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://git-quick-stats.sh/"
  url "https://github.com/git-quick-stats/git-quick-stats/archive/refs/tags/2.10.0.tar.gz"
  sha256 "1ddd005867b5260f51416d64c43e6076ccccbeb2966d08d2385ef4e711c4d9fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "542db70ea560e83b2ba9de5be3805c06cc4aa13dad58b79672db92dad4ba77f4"
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
