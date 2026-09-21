class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260912.ea09098.tar.gz"
  version "20260912.ea09098"
  sha256 "505832fb4d82682c965c84880fd42edfed6dec5f0930b55a4a6474bfd89044f4"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ec9b6c87bd437d2690e543e944ab71bbe2206dc48c961791705c87d9f6babaa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ca4cfda8fb7e082bf8e2681dfff8a606ed2132b2b0b4930884448640af4a1617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "148e77535dd7f648cba507264d14d7251df58c48e31c4b060a73e295611d8e78"
    sha256                               arm64_linux:       "5f17ff93a09ec823d60d1283871c40e1285e8df285a530cd3cc4578469c2aab0"
    sha256                               x86_64_linux:      "dd58099fbd370db9cab2f993fb227b65c7822a9795fccc2e18bcf0f01f836965"
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
