class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230128.a98ac4b.tar.gz"
  version "20230128"
  sha256 "d28baf495d961c30577c459ba6c6809705874da28d9d4deabaac7cce9b1487dc"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7e45576bf868e002ed7505262abcbf86e243604954921c9e96b51bfbf6cb64b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "862d02af4a4433f60d6eb519b5d2a13517e43cf4e62e70b69daed09a8a7e6103"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9aba9192fef634f3accea8e0553f212d911c02c68409c68721c68c52b338682"
    sha256 cellar: :any_skip_relocation, ventura:        "1db60e30cbad43e93f897e6d285a01608df31f3dceffc71f87ac7a4ef67f8c2a"
    sha256 cellar: :any_skip_relocation, monterey:       "0814dabf1e3b67671dd81084bffb9084b20594fd6cb0fb3440d35146e1c9ba64"
    sha256 cellar: :any_skip_relocation, big_sur:        "afadef3dead6a00cbce0adea357d6e40f8232d9a227306b9294b793ae3187a77"
    sha256                               x86_64_linux:   "cc37e4c3a0b878d19933aa29ec3179722cd66a76c75cc0b37fe72012f9a7948c"
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
