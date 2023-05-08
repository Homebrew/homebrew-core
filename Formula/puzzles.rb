class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230506.d0f9792.tar.gz"
  version "20230506"
  sha256 "456aac07f7dc4bda7ae80ef7f8c0d13c20299dde270d8bb425c0319212be2064"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "105f674aec54131cb18ba0201ce6ebf8269761dea9e0f7862b004818088d10d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5275b25bf882149e36992ebe87c200e390d0cace1dc27597fda977abdd5de9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4c98efe22d63c016535fc0b820efe22c44415769c5ca53aaf257ca6044a1b88"
    sha256 cellar: :any_skip_relocation, ventura:        "3482d38611c84d6c81863b7257efa95227fcb71c350bd08484d36bd3ac08ae26"
    sha256 cellar: :any_skip_relocation, monterey:       "cc115229bac4a7536b71737adc35375c7bf0188668173afa6a3b3aff36e5dfd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "e598856ac19957dfe362ea057f23cb2b2178d7447b953b939cc6c4ff52333c9d"
    sha256                               x86_64_linux:   "544a9ac918857b2fd18d25eb8360c82b35c370e16de45d3adf167aa844cfc845"
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
