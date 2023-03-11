class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230311.8c5077e.tar.gz"
  version "20230311"
  sha256 "ac825e7c92c5779907281aeef9555fff2bb5eb29307ecfdc802346c8f482bf55"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185924e755d6128283d992dc907ba88fd8220c8f18256bdda67c4274cd53ba76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7488d49bcbf4f4b16121f9a233d434cdd09187c18c0a5389a31407c5e6db034f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2182d5c5445686e48ff878184648d01755aa45ffb83dceaae9d815a21d195387"
    sha256 cellar: :any_skip_relocation, ventura:        "455cbfba734369712ebeea5145d848f2855eb12b33a4a033527caa24dc62a99d"
    sha256 cellar: :any_skip_relocation, monterey:       "bcef656e4c09c8e4142ab020c830f48cebeb6997ff48aeb7dd09c772850d0574"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c555b8a2152702105225698b6f3d36d1a339c0235359772d6c0d55044cca012"
    sha256                               x86_64_linux:   "33f06cb7279b7f4c8cc66b391a1188d3ab56d49f21174b50a0f7612546dc6f93"
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
