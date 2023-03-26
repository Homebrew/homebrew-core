class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230323.2557446.tar.gz"
  version "20230323"
  sha256 "32feda0b05b66705ff485514f4f18fbfddeb61750e13f11ba1825a56301442eb"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec16dd0f874376c821c05972d8721a6a8c3826dd00d422d62c513c6361cc5009"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0846498b12c1653ee94cf6f999c5bde110a252c442667b030d84adb39eb8a05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0478f906db00c16ac8e37d58272beaee0152c5d595f6222daab08c4edaebfabb"
    sha256 cellar: :any_skip_relocation, ventura:        "60a99461e08d1cc061cfaf18b5507906f9d043ef14357e81cf3708965de9559f"
    sha256 cellar: :any_skip_relocation, monterey:       "d58b80611c1e0420e457bb13e659e2861967d5600f7138ac8795c70e255ce66b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf1971c5e75b271735ee1034728a9f75c8c5fd7edac5c5f6b7a972dc9d2836ad"
    sha256                               x86_64_linux:   "1962218b5c625b23607d1c56328b7f40d8a63668f3ab43bb64b0ed69ad0a1530"
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
