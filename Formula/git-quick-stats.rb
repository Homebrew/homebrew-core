class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.2.0.tar.gz"
  sha256 "990dafeacef180c5f46e537e44416137fd9f5442a139c7ff1f0f50a16beb9287"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4561f638755f0a240f5e803ee499cff06630011aad663edc812672f27e27eb8"
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
