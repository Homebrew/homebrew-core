class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221028.1e8169e.tar.gz"
  version "20221028"
  sha256 "917727fa6e15ffafac031958aca6ada924278c3ca904a7c389b43508cf4fe169"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f61658976aac6b8badb5517397a691f276ba617bdef8bfcd04eefe18565ba63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79637d10de45423956c7396a8cd6c279e8bdfa29957ad8844080e0f3be3a77af"
    sha256 cellar: :any_skip_relocation, monterey:       "d960f0dd1007e80469c6d781e5ae6f42c04f2ae933ba05bec38c1bdd1ba84b29"
    sha256 cellar: :any_skip_relocation, big_sur:        "32e300ecc06d0084c8306e8bd497af5758d4e2a76aaec938f5cd43eb738a41ba"
    sha256 cellar: :any_skip_relocation, catalina:       "66011bf3565fc08e93caecc5d4800601303d0f4656a1e31647eec683a330783c"
    sha256                               x86_64_linux:   "c933cccf4c93d7ce83214918cd737bf1ec0d93e304fafb9c33b80c74a9cdc180"
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
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
