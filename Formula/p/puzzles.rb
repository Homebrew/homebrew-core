class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260923.616da16.tar.gz"
  version "20260923.616da16"
  sha256 "cc419c8060b4e22be398aa03e30651fbce146eee510645c303fb6f5f1b77b78e"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8}(?:\.\h{7}+)?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d2dde5e14b56e30fe518228a95d073c69103d83966e9bda0a136bd6b627ccd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f37b6594a62e3229ed97777a339ab9c76dc388c1b2564274545fca7bd669689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45b6378ea2b57396d2585ed89fc028dc07a08eed9b752022e7b32b106ad7e888"
    sha256                               arm64_linux:       "6b537ec6936749be286578a522797822c71a9ee4aa6081c7f60603a65ac98ebc"
    sha256                               x86_64_linux:      "6c87fd9ee8319d796dead44d88c6647394bb1cf493cf9979839294db3d14c94d"
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

  deny_network_access!

  def install
    # Disable universal binaries
    inreplace "cmake/platforms/osx.cmake", "set(CMAKE_OSX_ARCHITECTURES arm64 x86_64)", "" if OS.mac?

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
