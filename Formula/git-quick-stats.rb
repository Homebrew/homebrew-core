class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.3.0.tar.gz"
  sha256 "28095fa6ff57fb22528793e58c0d571829682f81d4a922825c8f82830920bf9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a698afab82d96b64a6e1754a5ee97fab1dc5def395bc4264eab68e4dd33f95c"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match(/^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1))
  end
end
