class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221031.06f6e87.tar.gz"
  version "20221031"
  sha256 "206c29d6695efd0fbb47ded1f1a1fe3df88cf1a5a85933af7d12d0d9325a128d"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81bbb6d43f13f085c3f72de901d969dba6d5928d2c00bd290ea443310aa05d42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1305c3397a886f6ae87fdf539aef381cc2be6d87e91ea9b84b29e6b7d250656"
    sha256 cellar: :any_skip_relocation, monterey:       "5e30be87f8d59b61cf5e9bb6bee30b8b693392e77229d1bca36ff2981cd16369"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25df51418bdd1dab4850de4a0fae761d219edc178af665135f5dd2820365756"
    sha256 cellar: :any_skip_relocation, catalina:       "3dc7664867f1b30c7d29436f4efb5161d089d88e6568bd7d3db5f26bdafa0403"
    sha256                               x86_64_linux:   "77eddc2e730d0dc5edba03cbfdbd186e53c1c406beebf4d90762b47c92448525"
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
