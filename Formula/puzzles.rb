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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f937e9ab473db5330b46ad0f932bd1a58a6bd1a8e1416665173ad8a9bf718c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bec5096f0a7415e4ce46a22fb458425c13c5831e589343e18cc93f20724e1b3"
    sha256 cellar: :any_skip_relocation, monterey:       "9aa2fdd3c4916e067b8583afbdfb692192509abc6e3ec33d2a95f169f44f8bb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "44d6a92ed7b621ad0d06b60fb0ffa9e822b00bd51ff320c3295a96c297009894"
    sha256 cellar: :any_skip_relocation, catalina:       "8a3dae23184e83092224a205757ca5a30b7ceade49703aeedc01089e429e4869"
    sha256                               x86_64_linux:   "a3fc1703f6e192c92dab6a088ba6fdecf26bb6efb4bc92c85054c71814ef54dc"
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
