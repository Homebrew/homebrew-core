class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://git-quick-stats.sh/"
  url "https://github.com/git-quick-stats/git-quick-stats/archive/refs/tags/2.7.0.tar.gz"
  sha256 "5392afeceea9dadf7f8fccd05244a6e8c6a27940d6abd1a97f65533c27e56379"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "98e56ac6f29f242ab0ebf28f36e61f6da00b6119359056f5c71fa8a4689ee9d5"
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
