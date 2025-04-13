class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://git-quick-stats.sh/"
  url "https://github.com/arzzen/git-quick-stats/archive/refs/tags/2.5.8.tar.gz"
  sha256 "75a171042472a0415324c9e903e80be24c2ec32d366a3e1f67ca838a33ecad8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "de09916b90af58cd011cf6faa7be119d581f0ea26a8dd16f66e94fe865aa8298"
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
