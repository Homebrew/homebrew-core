class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230607.7333d27.tar.gz"
  version "20230607"
  sha256 "1db077d4d9ad3fe75f917fca1304f248162b041ec35f2c709333c1080b2b3c0a"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd86c970ea9229b5b46d47e8c59f4ec23d8606cbf6229ac57489ca91f60adb6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a971582d3c176826d2cc3e94cdfc18e5bdcd58c0fc21e0ab16d8063d0cf6dfc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39bc0a1ec1728d5c12e82ab141bbe7f3c7430c045075b864651c2591a936be02"
    sha256 cellar: :any_skip_relocation, ventura:        "2a4d7bd114a5ceb1eb835de9474f1b9da9040eca2792c0084f0b650e00f049fa"
    sha256 cellar: :any_skip_relocation, monterey:       "d1c381ea86e0fe703be555cefefeec67cda565357eb230ff478421473e9fdd87"
    sha256 cellar: :any_skip_relocation, big_sur:        "75451727d077bda4c45ef4a09c364f1efc058c79f510beea088d70152cb38028"
    sha256                               x86_64_linux:   "34282572a0e7f6ba33b95d4171701553a5a56fa9e4f481e971af233a776a8867"
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
