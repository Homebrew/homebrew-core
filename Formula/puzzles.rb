class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230403.8d3a93c.tar.gz"
  version "20230403"
  sha256 "6fe48bd13aee9e40bdf62c7f352f999c8038550a03f7b39b927528a274d6086a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26e0f24043314d3a3fd1aa2e89224f37b792ab2cb4d3995c3ec0211601a0b8e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4d22bf430455c435cd00b0f04faafa5f8c12ed0011982f3ee6ec7dbbd654fc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6377c0e28b33a71c4f4cb6aaa7c4e0344317116c2d57dc49ab258ec54a3b63f"
    sha256 cellar: :any_skip_relocation, ventura:        "4089ec3c2192aa0df0d290f77c2fec4b44eb095b2384cc726a7890f40b7a4205"
    sha256 cellar: :any_skip_relocation, monterey:       "fec8a77a948326ca4ead5524ea9da246aae3920693d8fc9eaede74f0b1a07394"
    sha256 cellar: :any_skip_relocation, big_sur:        "346d777adabbd816535fecc08b5ed79fdeed97b42f764cd0454f211923e87656"
    sha256                               x86_64_linux:   "5700ecd8a3eef7d550bd69cfe4e0a2c95c00a96132f4a95d25812491ab42e75c"
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
