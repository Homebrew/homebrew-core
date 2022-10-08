class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221008.85d2a7d.tar.gz"
  version "20221008"
  sha256 "3a37c808222076449e1482895090efa347afa3f72e8e87cf5422ae48450a7807"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd1eafade238308250d7b6a649b07413ca9f1cba8b423652caa327a6518c020a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e4df14646f94c23debfbe722a4127c1e9d93dc9e2e3dd14d92614ac0188020f"
    sha256 cellar: :any_skip_relocation, monterey:       "8cba071a624457d083747da428b5398facd941f7742fb3962a2c8fdb519d073a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9973e378a34bd9c68be16337bb51e5dcbf8ad57f97f082ade9c90659561eb08"
    sha256 cellar: :any_skip_relocation, catalina:       "02dd27fe5c8a424128318aeba76ecfd794783048696b2eb5df95224c1bc5e816"
    sha256                               x86_64_linux:   "b5a9894d05a7c02f03a669cf50301f9f67558332e60fefabf66138c034c57bb4"
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
