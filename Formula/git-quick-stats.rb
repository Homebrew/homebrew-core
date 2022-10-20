class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.4.1.tar.gz"
  sha256 "b9fb1eca95341939a575086298f9d3a869dae41e46946dc420128534dc3736a7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "479a05181d49dd93ca8da80c6dc995515071840a1ea6f633ea6700379445457d"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
    man1.install "git-quick-stats.1"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match(/^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1))
  end
end
