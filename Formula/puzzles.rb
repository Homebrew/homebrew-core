class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230313.adf2a09.tar.gz"
  version "20230313"
  sha256 "32944cff9cee74f9b3e44d31c9e92492dafaae7b6477acbe3bc20b0775e60508"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abfb08fb56148276dee1470b5420f6a5bde0ba9b285237da84ffecff640f43df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42649b484e2a16bf8cca457a2c413c030ab16e8e8813e245cad87573a4f27e8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91e29408ff73b8a71889b8b443e03039a205b9fbccbfc2aa03a23ffdc302d9ce"
    sha256 cellar: :any_skip_relocation, ventura:        "2d3f9c6e7eb3b5bc5d1ac9511db3946aa1643e83e8a6c403fdd251055744970d"
    sha256 cellar: :any_skip_relocation, monterey:       "4592c60419de4f562ff43cfb7f61a483ccee7ebf18e6f5af8a62f6db56f3af6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb93a2db543563df8df918b9336fc886b8b2f97b384324263310032f5faa397d"
    sha256                               x86_64_linux:   "b209e6b4a323448e67540a484ed37b2c2f600285ecd60a36c9b3a7ff9436c87e"
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
