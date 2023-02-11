class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230211.ad2fb76.tar.gz"
  version "20230211"
  sha256 "6a604d4bdd81cf5fd5f23997fd0a78fc933143d7927fe86ac7d6837fb98a700b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8ccc891d377b7e7453ca3a8123cba976be3f747cc997362b138a3cf8890bcb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e118e34a15e6a9fafd4806f55074ec42b6409e3e5087bb107d2ffbdc464104b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9a4fcdfbd21a318d6b1f724ea78dff269da6d7262a4b5a56c5dc3203eae35b9"
    sha256 cellar: :any_skip_relocation, ventura:        "87c1d38dde8001ce40ab0bac40832d15319e7a7f17c700466c451fc237cceb2b"
    sha256 cellar: :any_skip_relocation, monterey:       "23f541370ea9466b833766226610317446b083135a086831ac68d65f86025ae4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff647f0e755a45d50818851ad47e18a8c3977d8c23182a3105ca5fabe01b433b"
    sha256                               x86_64_linux:   "159a1a75a523fdab823e0d4c3d6d0a0982588c1870ccadfb3848fafaf8849d9a"
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
