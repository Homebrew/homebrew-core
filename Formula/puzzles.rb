class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221119.f86623b.tar.gz"
  version "20221119"
  sha256 "11e7a20e67a7cb4a96310e0a712b71149d2963e14f18825b7aaecbc5291ad170"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2fe25e9bdc1588bc99ec9d3569c8d90ef4595df55822573d662d0bdb7cd12e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "585d810fc3f6978d692f0d0ef14127377ac640680b2e7c4e925bde18a935f4ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31d1282e0e510fe2ae6872ab2c36996cd00f068b6a09594b6b5ffcd32b7abc8c"
    sha256 cellar: :any_skip_relocation, monterey:       "8e60a0ab1138130c4169f8f2603a2b7bb8b2145b844ac4778f149754a5176b1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cfb3a31ab26f586d8b1b1266904232c14ad5592b38a4026992138c099f3ec02"
    sha256 cellar: :any_skip_relocation, catalina:       "9e72850c20388bf53c1fb9ce5cfde9331c981b92fec6c2af45548e7825968d39"
    sha256                               x86_64_linux:   "fa995883186895988934ca16f37b4981f44ef7e7ce8267c47d63e46c16a3faa8"
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
