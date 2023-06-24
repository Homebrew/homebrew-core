class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230624.1d56527.tar.gz"
  version "20230624"
  sha256 "924c3efd8ab0570c1619041bc6f22aaa8d601dbd32e875af8b9fdf3515e9ddf7"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd7be288f8aad96e04d5329c78768d8b0b0c6bc67c4ff126b5455b524d23a2da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c6514949c812065d8184056a0d746f179ef5ed8c132c15cd82fc959111d860"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d72633ad06f1598693d152039281663f7ee02a2f9be29b3402d08b2bb15a05d"
    sha256 cellar: :any_skip_relocation, ventura:        "5d3a7aec943ed6be33d20ab815b1fad7c985937ed25b92c1729f06533e2b5ba4"
    sha256 cellar: :any_skip_relocation, monterey:       "d4cc919bbc8fd64b34978adceb5167c58ae16dd859fa1e42d0f0fabc6f59ba31"
    sha256 cellar: :any_skip_relocation, big_sur:        "41784de21f1d8cbd2b73abe283366961d4b4ba1b69fada552009c2191b7925e4"
    sha256                               x86_64_linux:   "7b00dedffe4700a72ef5e5f3499bfecbe59230bf1042d55d6e85228ca7c0aced"
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
