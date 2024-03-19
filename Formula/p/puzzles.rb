class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240302.80aac31.tar.gz"
  version "20240302"
  sha256 "d3e6e61aae3033ed3f95d433f2278a764b86d071dacdcb50afdba5fea2d3d208"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "905a0d992c3700c9603488fb7f9bb80d8feeba099b0ae60fe3dda84e6f12ad9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9716c6a7eb7471018ab6b9173d61af7529b2ca426e3a112338fefd15a61358ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e604035cde563e85d28604e8f34fcc85c07d7601160aae9de79d48fdbc9426"
    sha256 cellar: :any_skip_relocation, sonoma:         "69899ab73ebd6141c618a6a64023a21f7d0c33bed9d2f98dab6fe4c85c00ef69"
    sha256 cellar: :any_skip_relocation, ventura:        "01327ff3b71c37a280425102c067e2bc4940e8b2d688c4c7f70a9d30fd67fdde"
    sha256 cellar: :any_skip_relocation, monterey:       "9243f5f903fb41584b3cb1c9077b723c6a9ed6e8a01048a2925be76913aeb80a"
    sha256                               x86_64_linux:   "902d923b2150b3840f7f52b08917ce5361ba70ce0392bbd9b34e476a38a92744"
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
