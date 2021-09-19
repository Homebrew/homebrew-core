class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20210911.d204978.tar.gz"
  version "20210911"
  sha256 "a0aa6e1011b71afbf4a58419104c1f8f896ea627d2c59132a64e6e54c93b6694"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16a0dc9713c38c493a8ce63b381b51fd6fb1f0367b2a3596e8b0525bc1115c2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5a737a48f3fa159f8b098f7d3e77c2c996d4f6e9032e3b6544062905af67f9e"
    sha256 cellar: :any_skip_relocation, catalina:      "75cbaaffa4082480e6e7d25a7eb468bec35ada2b4a799b45060e21145396d3d2"
    sha256 cellar: :any_skip_relocation, mojave:        "059b65105f85e908f01485c2c8f1310d1c0b43b6dfe75e704ffbf777b0e23b78"
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
    on_macos do
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    end

    on_linux do
      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
