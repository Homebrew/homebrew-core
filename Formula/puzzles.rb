class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230129.4359f59.tar.gz"
  version "20230129"
  sha256 "3cdbde7213019cf7f192952e368cb408f255153db8ef062856a76ecc19c738da"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87d460c196d15ca277d5109490f2b4924e9ddabc04a40271a8e671591345517a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d1eaaf562c4228fb8c2048a8822cb076c22fdb39356c2e5be5aedcf5e758791"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6349fba5b6e6685db556427c90cd7f088a1db1c477ff431d6931ca4103452610"
    sha256 cellar: :any_skip_relocation, ventura:        "08af37e68db48ae5c96065121b8cc3788b8587e947fe69ee91e22f72a9da88e5"
    sha256 cellar: :any_skip_relocation, monterey:       "f1469d102e5f947357571749a3670e0341f785f456b63c502571faad00e7cdd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "346786bd65d20bd0cfcdf43883188511c7c757508065f5790759c5a81d18e760"
    sha256                               x86_64_linux:   "ec0623311108142a71ad67ca56db18893b4189e5f31eba49e5224d5a3a433bf9"
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
