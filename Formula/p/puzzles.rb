class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20241230.79be403.tar.gz"
  version "20241230"
  sha256 "816b77dbc21cd3e72d729b678674e9ac01263297297c00324c4a91b8a1748156"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f454115119d50e1470b12dbc4841082bb1e69541cd72f67dae238145fb5b4423"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d69e96c2722cc925465e266076155e735a7d2c8202f3b0086a4b9fc7bc96000"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f031ba1e2ae2a13e1c265c773084397928c93b0b664bcece5b0a2c5bc84a02"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2774883b55e7e995164ec8ebef4ab239e82d67f4d0f8d65f3e9a9ecc9b2688c"
    sha256 cellar: :any_skip_relocation, ventura:       "cdbf1b04cd3f8852f15c59ac023c8914e60d09fd48ea60a649fe353f3e108126"
    sha256                               x86_64_linux:  "6839fc0f1f6dba7e382f6e255ae8afb3343d1b38de99efd671ed63cd9679f649"
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
