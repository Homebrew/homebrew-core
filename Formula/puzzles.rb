class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230417.0d86fe4.tar.gz"
  version "20230417"
  sha256 "c00dfaf1dc0c76f7d66141ba13a18b679818d2fe06ed167c547d6395f9660d8d"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e90546d4903cf588567964ba86e71a90ff480338f45f056500230d2198639182"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b30d2220b4ac5fecfd9697936505dbc19f0c9ab7d0b2755c1d848330a9c47f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "131fbbfb2f32c1ef808aeacc63203cecdaa25334e75aeb0a011a88c5d2cbde0a"
    sha256 cellar: :any_skip_relocation, ventura:        "500b93b46414eac8584f668929cd52b482e57fa8e278fe4a6f4ed7f0b0d1e6c3"
    sha256 cellar: :any_skip_relocation, monterey:       "faf583a0c955122b5b4f3b77f45dad57554d3ba5dbe97c2f7cd39616b5b30d3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe5a99561f3ead70efb24efe8389e8f68a65db0bc1392aac1d0cdbbeb71c5154"
    sha256                               x86_64_linux:   "6a11e8fb59691ecbb20d0a157272019b7947969547184ef7222bf6d6f3666452"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
