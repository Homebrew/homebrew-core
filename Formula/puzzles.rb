class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230306.0156900.tar.gz"
  version "20230306"
  sha256 "25017e2b84be4f1a00c772cf38d04c51a59675a11755eaeea976dbfa31851721"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "168f7044dac99330576c9b856683c2791f95370be806ec0d8a6f5c3e245ddd49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4fd754f840119b29f399d97ebac4bc17f4135506d061bcab2f364e89275db82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba4c2121670ce1564ebe3f55bf1410b50b16ecca8565f293bc419290090ac585"
    sha256 cellar: :any_skip_relocation, ventura:        "1210311dfd8f9214a6efa3fe3b1d0c3a410d544e63b605064047b1afdec4483f"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff5247c39b2dee51856da68cef268c203ea8b6874535fed3e06670741f66f19"
    sha256 cellar: :any_skip_relocation, big_sur:        "381d219b49acd156dad13ebdf654b4a4ca556e48c751009825ee8f5b4351dc2d"
    sha256                               x86_64_linux:   "00d3948f62b0d5b510e1baa377535ad7be73c4c2aed1471a15924af1eb4be713"
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
