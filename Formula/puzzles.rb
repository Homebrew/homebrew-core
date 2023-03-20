class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230313.adf2a09.tar.gz"
  version "20230313"
  sha256 "32944cff9cee74f9b3e44d31c9e92492dafaae7b6477acbe3bc20b0775e60508"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab06b1168a495f514720201b615a2261091a0f7e899159583a0a84029f9296a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc92dd2f07184e60d70a3763e51b2ba3b62fd801c198f187d181e9b1d7822d96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "799e4a902e83331f65349e0cc1961be6232dbaee6fd8f80518c424217bc549d7"
    sha256 cellar: :any_skip_relocation, ventura:        "4b3942635a9eb1769d32d8c26d65ea5e7534506386fdadaab0799561be2d2cba"
    sha256 cellar: :any_skip_relocation, monterey:       "e99fa334bf9106c9ccd23bd3518489da1997d0c1a38389735bb066c1e37ef6f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "759ee66eecd536ecae22c97fe70499546da9cf8cc3403f49c3df569b56c4038b"
    sha256                               x86_64_linux:   "bb67db96763756c4aef7090d1ce9a28ba2e9b5f92ff94c248cb17979a0c37000"
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
