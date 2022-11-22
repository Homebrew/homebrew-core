class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221122.2580391.tar.gz"
  version "20221122"
  sha256 "d272275e3f94c4c3d25a37f0de4ccb45f2a66ed7ee84acc0c4f65a2ea8f2ceae"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0117d15b6070ce66418e2e3a5efeb19a1e891e34944624d5751ed8d0baf2eaeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb6236f23397219b26ca75d91993979c6a4bf1d0bc3eb0fbc4a26adcc6c76b49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a20cddcafbb586c839b81551c6d7e8b7efaafb921e7a49910c874ac08a69c68a"
    sha256 cellar: :any_skip_relocation, ventura:        "0c6b0830d97e73d0c97245ded7e23b14cdf28064642840b0bc2afe306a2c0eb3"
    sha256 cellar: :any_skip_relocation, monterey:       "c7c28b5d666b212c4a302741ac46b9e5de1c8a05830ef83f20ab5a242efb7eb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d323d7a46fbb96efcea00609870974809a3bdb3d2be140072683e82e384bd9d3"
    sha256 cellar: :any_skip_relocation, catalina:       "1dfbb84426dcb19a7783343f5d624a66a7b710a5fd0a0fe7ac8e6b8c0e677a0b"
    sha256                               x86_64_linux:   "74e88cea85ca5cb71d50fd047301a078b38fda839e3cff5927c959ebf6bba0e2"
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
