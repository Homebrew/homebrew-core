class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260410.06e37f1.tar.gz"
  version "20260410.06e37f1"
  sha256 "15d8834cfc3775fffc8fefb09064f13b706f9cac3b38817cc572cdccbc3cba73"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b077e86b5be9d694c960902d8c20f7066fbd52a5dbf77f3e8ef289d159eea6bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "732989e02c09098d2970e3b3252385b821d58cb51872e55371142a28b6edc6e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4c335dbaafe39ba6d33a05b0f6718c7d4d81cb3dc61a94bc074fcc152d8d29e"
    sha256 cellar: :any_skip_relocation, sonoma:        "68dc0faf1e75dd9c961d9708a6c4fd8cb8497837b0dfb7a453f1de50a913f5ad"
    sha256                               arm64_linux:   "7252399c49a87a2c21a490e839f01ff726cbae1cc6aa33fdcf2630f60676c876"
    sha256                               x86_64_linux:  "8e90b5777ee60300f910d3a24fa2724ec1a11a6f07d1eae8e8182340e85cb307"
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
