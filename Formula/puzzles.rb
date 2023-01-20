class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230119.b5e02b0.tar.gz"
  version "20230119"
  sha256 "3defd8d25287e257b57598ac3af39527238cabdd117696e55c16fb16556e58b4"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "338423332fe97bad885fb7acd27ecbac7074130fe2a996f509a0a938f4990fd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4608ba5424dec75e89048d950b326d213d8a6e00afbe6387327debf3b7a805a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d29aaec00a25fd8e7c6d5702eee9180b7860c0edbe99f4d01e2a9b82869357ea"
    sha256 cellar: :any_skip_relocation, ventura:        "378986f2a964ed3193a5c1b43e0ef4a323a4aed4aff3df110897c2502e43a423"
    sha256 cellar: :any_skip_relocation, monterey:       "943e5025e89fe4fe3b00371149ba0fd6fa187dd03528e0557017aebfc4f64054"
    sha256 cellar: :any_skip_relocation, big_sur:        "25f0c11b02662be5d871e80a2058ef7565ea7f1993ea69e34989d6afadbf7770"
    sha256                               x86_64_linux:   "daa8d86726378baeae33bbdcf741486c9a6ecff614acd2c0f54950b46f55af5b"
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
