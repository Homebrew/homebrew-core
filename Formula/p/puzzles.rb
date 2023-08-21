class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230815.eeec6b8.tar.gz"
  version "20230815"
  sha256 "7b0b094f7492681720bf6799d11ccd68e6d60080d125f1b64bafc195d061a773"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fc48f0233e83e97b110785963be520ee7fc49852d47480dcab8b562a323e515"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6f09d002d25077866073b8c0326481ac765740c16a16f0046f2e799066cdef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f2650a91118674c1350f66a936df28df98db4b4fe745d5f67bc864906f24f1a"
    sha256 cellar: :any_skip_relocation, ventura:        "e570f8789690295cca5407fff6b2c088560295be1c8e6db065410d0b325f7469"
    sha256 cellar: :any_skip_relocation, monterey:       "f34497a1e38b9ee47d44405e9afb11793258bef827dd3aa5d287b6fd48cb3101"
    sha256 cellar: :any_skip_relocation, big_sur:        "0908cfb7bee9eebf1d2b67ce726ee38e885d31081a456cd20ccc72ce51e1330e"
    sha256                               x86_64_linux:   "e0171e6a0f256a5172f150b05dbcb2e98fafcbcf9f51d29169fc1022b9d549e6"
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
