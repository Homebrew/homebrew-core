class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230119.b5e02b0.tar.gz"
  version "20230119"
  sha256 "3defd8d25287e257b57598ac3af39527238cabdd117696e55c16fb16556e58b4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fa1742ba788c000c544ed7cb2098eb6add00d01b1523bd2580892782203d355"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ece4e0345ab5764512bbbf0d176133b3b9d3e344ac9ef9bdefe11cd0b685b82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f2e86ff02ad4a9f4e8f132417adbc878a721a2c49906bb7b1c363b0d2cac2b5"
    sha256 cellar: :any_skip_relocation, ventura:        "df2272026d753e89cc1a13bef44efd769a99cdc4f5fe05b6c50774a76c279402"
    sha256 cellar: :any_skip_relocation, monterey:       "4a82f7181b712a6ef36a7391dcdfbdf8e91a2d11aa9518a07a207eb468e6925f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f503f99aeb50365b0c9c26a7c4aa1ca974493152948fbb92a0c6d6fc845786ce"
    sha256                               x86_64_linux:   "27a18837ca5c48e9a142925ae862f50a07e718038638cfacb14e29875eb6b0a7"
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
