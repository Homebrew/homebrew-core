class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://git-quick-stats.sh/"
  url "https://github.com/arzzen/git-quick-stats/archive/refs/tags/2.6.0.tar.gz"
  sha256 "3ee301875edb7a9689d3fb1746e8e0d29c13a62f64d349847232be447ac78206"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f019570962c4b96ff7c9bb3a526ed2570b8a8241b6c44eca092359164a6919b"
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
