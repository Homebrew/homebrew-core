class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230116.5782e29.tar.gz"
  version "20230116"
  sha256 "64cbef5b46e0ff41097e7e02adcf7e81cb9aa52345758110570c44f6e9f9dfdc"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c712a6a1955531f60b439fea95d320445d4c627098ef0c5578d9f54eb42ba9a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "109e1b737235d2ee012896d7dcc1d9ffcad871686e70673d7e6a9d8edea4d20a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbccf485590b153938b3a042586673be00a72e13cceb1e15d13f8d2424392129"
    sha256 cellar: :any_skip_relocation, ventura:        "2371b93e45aea63865116106d46b6d327aee6d3d54b2e832589134e8ac946a1b"
    sha256 cellar: :any_skip_relocation, monterey:       "3e7638060fa6324856851ad59819da3dd578fb1283e3295085a696b3c9c233c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6ccb847830c9c113b3ee53c2d5d61437784cf7fa1af927d50b164a5923741b9"
    sha256                               x86_64_linux:   "a302e92ea223913ba53b9b5fae4f26fcb6d76460deb7a016fcb4c2d5725472e1"
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
