class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230623.6db5cda.tar.gz"
  version "20230623"
  sha256 "f7196455847800c0416ea0b04ae0dbd76a69943f1af24eeed0f179dd4e1f1042"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dab11a41f91747e891216aa753561ebad577a71643afb25ecc15ca5eba582212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8dcee2c30caff180abd4038fedf48815fb22dc511f4b2292e75f40ec6cb235d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88dbea56bc429370c9811181fe7e7062084d91439a1e51d6547bc715aa901195"
    sha256 cellar: :any_skip_relocation, ventura:        "07bbc9dd6271707d15c9f6d49e1bddc06d5e451702001af3e341fdbc1230f59b"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ac9f9583d8290f8209ad92b44b6d49fc916b5b4e16e5168da57b145d65e634"
    sha256 cellar: :any_skip_relocation, big_sur:        "247175a6f19dc4bd6d7718ceea850f09632e9391b60455e94c7d28dd61d83e86"
    sha256                               x86_64_linux:   "fd2ef43c1c39ecd9490363f4f336f6f287b7075a424fe0db06576a8f7bdd15ad"
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
