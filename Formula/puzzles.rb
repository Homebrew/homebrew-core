class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230424.e080e0e.tar.gz"
  version "20230424"
  sha256 "cb8669b753b56471a080f31965f4b894a58a7c33e34225529ddeffec94350318"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c437d58ffcc80a5073e2b5146efab68c0897a206110995b3d2ac7a582d37bf87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "202cf78e485479decc140d9520d68e0c4eb2864a013d72732ec8f20325bb6386"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdd019335ada76d37f3b0b395e2b727ed8abf201bfbe289fdcbafa4fd59c6987"
    sha256 cellar: :any_skip_relocation, ventura:        "835da891d4daca9d85c132a87c4508c9f670658599c6067022d402554be3839d"
    sha256 cellar: :any_skip_relocation, monterey:       "5c43c550e8e37f5977ddba97a49e7a801ec0f926c749268e2c9a03f07dc4b9d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e913a892df5a547c90abf850f9b74f2b515f67569128aa0c9a7483bb1d87dd6f"
    sha256                               x86_64_linux:   "7e41889903d3c53f6f1778eba0a90d4be42bae1e234ea57bdaa68973454ac0bd"
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
