class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230117.1dc1ed7.tar.gz"
  version "20230117"
  sha256 "d4cea35790fad6311821c2a3a38b3ab613c18568b9f5062ea92e5015437e1409"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3c4b14230095d52b92643530c2822e9406485ebd0caf73c81008b48011cce7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f006f5b6a1d59f82fb2514e7d4e06b76d19d5a693525d3a2284630033cc06cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ef3fe0b131a15b4285354c0888f834265c9deed7f057dcf5c548a5e99772655"
    sha256 cellar: :any_skip_relocation, ventura:        "55c5280fa97f919e16ca56404685b09a2f61b192cbb1fe0b9838ec24980ceb54"
    sha256 cellar: :any_skip_relocation, monterey:       "6f8d2acd3dbfaaa8e552dd2dcc5880af6f727059143b34b9e0560b67eec7712b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3989e39a8b93489c9048693ba1e675cd7e039eeb251d4452868dfb4e4c3fb8f"
    sha256                               x86_64_linux:   "2511e40091fb1900ce0dd3f66639227b585660e0a8373b891be7b079d77857fb"
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
