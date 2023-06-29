class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230627.8b8a277.tar.gz"
  version "20230627"
  sha256 "1a6839596fe1c41d3df19142b62563d14a26f5937048dacbcd405c221ba06de5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d1bc01c3c2fb522d7e64b98521d3e2ad2ca7394b565bf602d3240be63b280aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbbfed2b49cd487efb04afcbc1549c5830117c49c1c72188282dcdbbe067a99a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f87b98d37a72c4fae0cf940af5bf5b98228021735f6976512fcf86af75a64a4c"
    sha256 cellar: :any_skip_relocation, ventura:        "b89a260cb790dfa24a4d0a672a29b4570b912fcf34aaab8a8936f0f3d0d91f0c"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ef2039ae3eba274c401b07763dcc25726db9c852783095b96643a7e01dfe40"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c0aef4484535ad775f94f56b3849651c6b36ad5c1ce071f0d42d223465d8cf3"
    sha256                               x86_64_linux:   "0af0e73d44d76c00e413d665ac5ec52bf01c15cd1c554ff1210421d334ca2ba3"
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
