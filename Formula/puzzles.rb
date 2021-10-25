class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20211022.ad1c6ad.tar.gz"
  version "20211022"
  sha256 "3e78d925c81a0f1e6ef4a4f4fd70ae38274599ece22c43e1844e36c2b4dca8d2"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e91c37625afa7469e2498f5a471ad3925a819679db44244a88c04c2ac46d677e"
    sha256 cellar: :any_skip_relocation, big_sur:       "cf2e11cd4e6cb94a0cb4989f2e03f7aaf098abb816e13bc9a65f41cefbed7141"
    sha256 cellar: :any_skip_relocation, catalina:      "fcf2f14a0750f0fae886b30b79d6927d90749ba9887038050cbfcc68ee95b160"
    sha256 cellar: :any_skip_relocation, mojave:        "5bb134a4e1a289bb34e9d898be215448decb30af17af925744efac8a287ac7b9"
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

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
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
