class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250523.7fa0305.tar.gz"
  version "20250523"
  sha256 "927521883305d297215f30950a7b4a897615256f075c1a00307f9af4eeb9d9b9"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64f9831eeb1c079179de2132699debbf8d6d75531ec1c173f0dd5c47ed621a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf9117855cfc6615b67b6d0ef8d19e86672114be9f5f92005b47407ad9bf478"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab89521ebcc8bb7c417b03d9e18ec1275af7893167d5adbda10adccda71b251d"
    sha256 cellar: :any_skip_relocation, sonoma:        "83fc1b2658f6d68033764c8595e75e8653e76a3eebb8c164f2a08edf3fbe120a"
    sha256 cellar: :any_skip_relocation, ventura:       "40ab902db0dc20f3a6f8cb2000e8c28b93a0eeb84c3511b4d952380ada8d4acf"
    sha256                               arm64_linux:   "a28372f491807492c471cde765f04ae52c6fc6e1ba9dc4b382ad74e3c0f6a5a9"
    sha256                               x86_64_linux:  "c7718c014e8b34e82143d05922929fd67f6a0668b6b20b28c65ef34510dc8575"
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
