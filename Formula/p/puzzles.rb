class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240802.1c1899e.tar.gz"
  version "20240802"
  sha256 "f72e9ea630011ba0acdf59b74fff24f0e4f33ae6271ff8312c5122b517d1c249"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b61498dab0678d96e90261389ec27b1903691e2d7ab816c2f56b1059ffe2763"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6987356af49dca5b2c69ad64864b7763e8d2e12525ce49a692a68fb61eca561d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736370d0da34f6b1ea0495fc1e326e6d08b57729028a6682a70cbd57824f8da5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f766d82cb237f4f143588d2df587fbce2492607606903f7b852632948c8f936"
    sha256 cellar: :any_skip_relocation, ventura:        "3c539774f7b86a599bd4b988fc0685dd58e6bb9681f24b51e369498e99417d6b"
    sha256 cellar: :any_skip_relocation, monterey:       "52c6a0420e6b8b5df9df479270bbebe31ce6a5a905f2d9dd11f3ec7a42591fd2"
    sha256                               x86_64_linux:   "15c7d7391d33cdf17610b9b6a66ea99effdea4533d49d366d9ea68d356c616a3"
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
