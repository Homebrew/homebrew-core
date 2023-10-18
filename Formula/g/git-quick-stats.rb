class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.5.1.tar.gz"
  sha256 "5020ccdbf7191a6ac6f285519a597cfd54cd37a2827b3c42c2c6632dc83a6d29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db4cc58528f9966793d6b1e2f466f5b6cd4dc2f4f88c65510ac26d810f9325b3"
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
