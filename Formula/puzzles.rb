class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20210409.69b5e75.tar.gz"
  version "20210409"
  sha256 "6efc4939f8731d0613e47f9efdb01f0481d0a0c29c85435f59d78eae0fc444d1"
  head "https://git.tartarus.org/simon/puzzles.git"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "258181acee35e4ee0f90efc125a4eb9a59eeeabc65fcfc085359827627d0b39e"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bac5b3286d534c94c97ab731214461c396a796ecc94a303bdc1d7fb1d2781f2"
    sha256 cellar: :any_skip_relocation, catalina:      "303ca9a896bb4c4bb3cfe9ee2d0f4114e189f4b120b90d8962f516ced1acde0f"
    sha256 cellar: :any_skip_relocation, mojave:        "6661ea3b11959b5a9c07926bcd643c21b0809903155f385817c8bf4cc7522c4e"
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

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    on_macos do
      bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles"
    end
  end

  test do
    on_macos do
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    end

    on_linux do
      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
