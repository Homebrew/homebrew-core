class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20251220.ecb576f.tar.gz"
  sha256 "860877abda800ad95c7ce907d9a9deb10298444bb070b7e2b9c50c83ea79c56b"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8}(?:\.\h{7}+)?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c57ae64075ac9c134614a1e8b43934d4bc53867a83cde859f93db29982d8b82c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a05ac69230e73004b6b035e7d36d10b632bc92e8ab3e92887d9ced5cb6327959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db7814b987c6b70486c54aff72bc69752963cc31ae98bf913163d5cc3a9f30b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d08dbf5457913b9b3f881a5ef570aabb4d3df3235bb6c76a344cdcb0a6b785b0"
    sha256                               arm64_linux:   "8ec7a33e37ac86bf5517f9f47b1f1d925add0b9b19809045dd88819281bc549b"
    sha256                               x86_64_linux:  "a08aa824fe2f01aa4ad878d6e9a1697bb0b54e5c650852d79fa7a8d11a2b62ec"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkgconf" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    # Disable universal binaries
    inreplace "cmake/platforms/osx.cmake", "set(CMAKE_OSX_ARCHITECTURES arm64 x86_64)", "" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
