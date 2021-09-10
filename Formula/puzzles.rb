class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20210907.6691ad1.tar.gz"
  version "20210907"
  sha256 "f65ff02d50ee53c9cd64221d54f5dff8cc1ac47405a5ec5532294ca218e127ec"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "320f100c895ac11b07ae06d27f3f6175504f2e73e60f5f9ae67aad8e636c06ba"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c0b6e15d1c1535640dc292caf28d2fa57ce8e0c1e8ffcf953f6351ceeb59f19"
    sha256 cellar: :any_skip_relocation, catalina:      "dbe2e28663f7916ddd0c0d0ff9a9935acad93a4439028084ef9690f5006240fe"
    sha256 cellar: :any_skip_relocation, mojave:        "b25de2654e4a9279d1d28746e52f243cbb3b82e1d65a7d63bcd23e4ea7dc4fa4"
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
