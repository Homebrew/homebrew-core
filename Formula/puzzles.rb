class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230109.171e7a7.tar.gz"
  version "20230109"
  sha256 "5d50c6fc76ef40f22d3b60126260ad8fbdabaa76d50acf2dff36b3c9bae7ea04"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22a461189698f7ddbb35bd1b9d09f83660cf1829c143b04e6ecc7c0409cf9da8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aedede488b55163c5573dbf3ff89cb8d42c5b2a409d788eeef064c9eb6d00c6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "416e52b751c64417d90212f7c78546027baa414ad5a026599c5558c281dddcda"
    sha256 cellar: :any_skip_relocation, ventura:        "78f2f9641b97ed10e1139303d56d628bcc3e7b9cc12a20cc53813973283814de"
    sha256 cellar: :any_skip_relocation, monterey:       "1e830f026d2fd21443cbb6a4393015c0416faa8cb29ef24a839b364051630e53"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb2b00cb8494b532f27fa264f6a6d138874bc85d19726b4b1bd54e6c7951adbe"
    sha256                               x86_64_linux:   "1931cf145e6c3783fb86fb7563adf46e3033b2a82d7bdaca49ac531638eec302"
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
