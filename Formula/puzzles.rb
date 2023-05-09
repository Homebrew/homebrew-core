class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230508.8237b02.tar.gz"
  version "20230508"
  sha256 "5ca75ff1fda1e428a9f5b85d9147d32c5ff61bb9443d647131b11f0c96d750cd"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6728fca2061d17049138888a0a83f15bd048a6045cc54cec0cf95fad12ae2217"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "391b962b0f1286cbe79f33254360982233625ca75a1a69324b9f9d72c07d197c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26c0c499651021f2e3d30dbf291e54052fc57af6fa137f1701b2913d4598c07f"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a5f6fc3a5ed0546119d0279bf9d3cfd84bcc8443129d8a977964efd41ff55f"
    sha256 cellar: :any_skip_relocation, monterey:       "e2b8632433126b5c3873d3feeaa84aa931c27ac14255e156e02d36098e9272de"
    sha256 cellar: :any_skip_relocation, big_sur:        "452260a59fa9c28ad37e92d4201798d4a8e878d5f972db8c0a80f8ef83e45fa3"
    sha256                               x86_64_linux:   "fa53e72330fe5784473648df59db2f9d6bdb7c9e0d353c9b4b20e2930be7e47a"
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
