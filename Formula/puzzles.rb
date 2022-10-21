class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221019.dbbe9d3.tar.gz"
  version "20221019"
  sha256 "5bea6cced5c76b3c8650b9072fed1a7026e666a83531cc46fa436858dda39bd6"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5beb74b673150ab7ad7269926c2ffe9a4e5a51fb84912d371cf24e906e67f786"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25442d72d9f923c02507467413dfbd3c9f0a7329d1d17fbbd8028842af7c3143"
    sha256 cellar: :any_skip_relocation, monterey:       "e1df67ed2808b409b1e04747f428fc9066cad18bb4731661f00efa55a9681c70"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe2339d5ff9483529a588f047f08bd9a46a7a388d805f44ee1ceff4d7a41ba4a"
    sha256 cellar: :any_skip_relocation, catalina:       "45f94acebd5c64af602cb81730dd29b51802da24133b7cb352029c431d5213d6"
    sha256                               x86_64_linux:   "5528cd44de4c0058b33782e3320808abfd10f3dfe229f56be5ad3b606364e640"
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
