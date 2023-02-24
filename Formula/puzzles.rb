class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230224.9dbcfa7.tar.gz"
  version "20230224"
  sha256 "8e91670e132ab720231043269ca28541e3f32ecc681a1863b3791cbb4416fdb5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa3f5bacf02607f2512855891110c32f4437df597ffdda0bd868dba924abbeba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f47334a70c5cb83475e01da735385941bf30ae35248f8586d1bb6a582bc7e63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7f237588d7147015327b849d0d419c4055653555fab4598d4c24d744066d046"
    sha256 cellar: :any_skip_relocation, ventura:        "727e5abc70a1c39fc0214434963a7c06bb3c07970da362818227e859a4957ea3"
    sha256 cellar: :any_skip_relocation, monterey:       "ed0e4e27d200d5b7ba9d9c2f98724749c0ef2fbc02e0079fbc54ead624c7bacc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5159fe7798cf5aa49a0f66c7b38d0b2796e7fd90e2559a16ee76c42320d35ce9"
    sha256                               x86_64_linux:   "85bf592fbcfc8ffe0ed8867fbf7017ce003d3c3fcd378c0bf17e88813491f203"
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
