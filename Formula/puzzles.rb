class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230123.b907e27.tar.gz"
  version "20230123"
  sha256 "e05b4b6c07d01ccbfdb5e4e216b6b474fc0387219167a891a3320405f180e86a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dd76b23ce3bad113a8a1af5d00bbadd68fa07121c091db6dd6e3fb0aa7aa226"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "004b24ffd7e709aa129e5ebd8d4d6f701e3677121c3154e3b72a63d3a36ba6d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e82aeb313e8628829a358a8d83d7c4f3bd6582915068e4c769db35e479cf0f0"
    sha256 cellar: :any_skip_relocation, ventura:        "9d427de0e8faf98e67a7c500c8ce7f14c428028a4a71a1afab5e97af7c959308"
    sha256 cellar: :any_skip_relocation, monterey:       "9894a8bb625cab04d82ad3c2701b16727212b6ef39804fd713b94060be398da8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f8eadbbc1b639f567653e18145bbacfee35cc575621978416041bda74816ca3"
    sha256                               x86_64_linux:   "1b18f59cdf0d2f39695b5470b070525c9edc2e848ba9260f8191df8dd029c3bd"
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
