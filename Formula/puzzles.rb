class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230216.232cbaf.tar.gz"
  version "20230216"
  sha256 "ed21441889c160fa721349ae69946e9c3d2e9e96170f24eb9914868cc0c25de7"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0bb9aec5ff638df045350b57c642e7b62099f8d9c79cd1fffa3c2709f452572"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95a314f0a7775ae0481cd7e6caa24fcc06cab7efdccca492f64d552e2d6766bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0683e1501ac39e4ff1f0576fa6da383b16667310cf7c8868c5df1b5ec83984e9"
    sha256 cellar: :any_skip_relocation, ventura:        "30fadd5f47784c093fdd533ed4ab5246d1ec6e086fe5fdec26f090b7ccba3c2d"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdeb5b12bfd3a5799b818f2ce50ab1c241115ab2cf2c13f9594da350a17ed1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3eb6e7592bcda2763d4d4373bb80e835e69ab1f6f12ad84058c63b52f785e52a"
    sha256                               x86_64_linux:   "faffa4846731094c15f2e2c7842b4fc3d0d815c09372eee0b118d155eea7ee10"
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
