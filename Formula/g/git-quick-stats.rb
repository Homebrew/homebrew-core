class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://git-quick-stats.sh/"
  url "https://github.com/git-quick-stats/git-quick-stats/archive/refs/tags/2.8.0.tar.gz"
  sha256 "6b3eef1f3d03eef240b3a07fc4691dd0c879f8ee64fb67d5785a1aa18a3ad887"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0b378f354eca2ceb53974ed7e7a7e44f5de8ed18ff8cda495a01caafbf6b844"
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
