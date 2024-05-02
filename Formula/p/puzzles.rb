class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240330.fd304c5.tar.gz"
  version "20240330"
  sha256 "bac12009f6de28e90083fb07a51c6e31c3c61f16fe279fabf7668ee00afb8940"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0114f8f6f8a15367d64e3e41c0c05e07f079f1530e9dfc0fa8cab5540422677e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e108c114afa50daf78ff0ce30c6fd5acef442984b38282d40baa9ef03adc0c17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6a75566679acb13d5caebda351cd686fea79e5823182e5fd818c46c18adfb2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a594d51be64b2cae1e884b82f8c921281ed133786ad66c47fa0051f18990b98"
    sha256 cellar: :any_skip_relocation, ventura:        "982990b33372efba5cacb12835328aaf8220d28c860156a33c5b5a5a13c1eb6a"
    sha256 cellar: :any_skip_relocation, monterey:       "9608af5adc21ed1858248782e6af4c5a65387e7adf8c018f51dd018288b67ca4"
    sha256                               x86_64_linux:   "522b0e8958febde8db217b158f2ce48ad98fcc925670ad8b4e89c02be6cc8dda"
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
