class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230223.ecd868a.tar.gz"
  version "20230223"
  sha256 "a31b3e5b5bf1e049aed948cf78ccc7b689f4b299b4f0fa5c75a1e15652318163"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ade4896cf26a85e10f7a4e1aec1bf69f1d7cca50c84907a5abccf06086c295c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65a101973abb79329df50437054b37d242fa133655fcbd22b70f6fa1264d0b3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49ef6c2b8bf325d23926abb146230d5552c9560ecccb2328d865b952db281169"
    sha256 cellar: :any_skip_relocation, ventura:        "80b356a32462405c090d11b9d14e8df9d34f4d267f252d67a50c17717f51d74d"
    sha256 cellar: :any_skip_relocation, monterey:       "32742917b3be7d9a4c1acd48bad682db1e3f249ee0b2ea96132ae295982aa801"
    sha256 cellar: :any_skip_relocation, big_sur:        "49d188dd20be102ad578edc585b2d6b046d4cbc6595d25aa8b8e5a0d09c68565"
    sha256                               x86_64_linux:   "e33ffa038c983919353d535ab5cb81f026aaea2e75f99ead92d8b60ebaa1c8cf"
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
