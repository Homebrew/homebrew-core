class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230217.1717d5b.tar.gz"
  version "20230217"
  sha256 "1a9c521c4701eb45dbcc9ae8b731257ad948bbe4fb50bf76385848e9f1198fb4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a441857cd96160b7c9d28485f97911b4327f72d259ae81b0804e2f56349a965"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "581a36ffe0f523dccdaab951998448d7ba7936507b61cd68c4415fac71ed4b66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31b5151e6c49fd713e183ff148b5264bcf5d4adf920ca8b551df6a7e7b4b5337"
    sha256 cellar: :any_skip_relocation, ventura:        "196b100da574c7057fc6d1bf7db61ebbf653a57373d3d3eb74e595aa4342ae1e"
    sha256 cellar: :any_skip_relocation, monterey:       "c9ffb5dd06489c4d08c7dc2299ebf3c3002290149997a9c63bb1d6257a632cc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6997f2e71aaa2c9d0c12e474030e3bf00be37db9f06933f55435a95140493e25"
    sha256                               x86_64_linux:   "994a524b163dfb7cd033f068dc26676c992624ecd2c2bbadacdc4416886b08e6"
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
