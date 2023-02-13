class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230213.c139aba.tar.gz"
  version "20230213"
  sha256 "565e4a60aa4a4421495e925cdd9c77f12bf054726bde6b9fe554a6a6826b495c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35bd0e35037c159aa2e4f06f50309433320208640de7e1e8c95f2b0e2dd53572"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cba93a2d538ac5b1424b40bf241f51cfe507617ae62bd17be44626c9290ac0af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78e5249673f908686e725ec1db910a63777957b522e6d1d1b898a37a17e0d3fc"
    sha256 cellar: :any_skip_relocation, ventura:        "9ce3c1e4fdc342b4d9db16ad16564004ca84a4a3bedd3f2cbe6e5d5c0cbfd6a9"
    sha256 cellar: :any_skip_relocation, monterey:       "4c8a3e3d32650f9283b7a43a0309c1afcc89d9f613d3fb7455d2cf9a3c53848c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdccaf5274c3dd0b120554aa9358c062195a16b6803e95adf847709cbe7f8a5a"
    sha256                               x86_64_linux:   "ba68f47348ee66c8e25ac11b86d7723169d686c0dd81785c0d03998cfa482f7d"
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
