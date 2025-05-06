class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250303.7da4641.tar.gz"
  version "20250303"
  sha256 "7f0a61478ef3515f87f80be3728d0395bf784de1feb3abfcd4c53f1fe99b1009"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebccba95ecacd2f2ba9538066efb4482e3ccdd7404516e8509bae34076f8f8eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "289f9d000ad1d4fd14356d0a652ef929215d6d25419e7f65ff4c0b0d6e3c7bd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8739712b883278230ef68d1ac4c8ff6251305cde2207af405e0e44a596cdf664"
    sha256 cellar: :any_skip_relocation, sonoma:        "89f28aebcd427dfc2d99bae6913dee7e78676050914fab9497786a3d4892004d"
    sha256 cellar: :any_skip_relocation, ventura:       "2c7ee6196f9a1f5360aad8beec6a586f3f4273a54e8713b16b1fc17cd351130b"
    sha256                               arm64_linux:   "ab9c8b395e4859f4cae0b6285bb610a6a0eab5d55981536cb2e2422b0af4bce6"
    sha256                               x86_64_linux:  "bb29ef58af08fd4f4279715ced6378ddac8b8374fe4adda40d96a868125140e9"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkgconf" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
