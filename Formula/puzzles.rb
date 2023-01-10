class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230110.e66d027.tar.gz"
  version "20230110"
  sha256 "7fbd9b22b05c34955f28d840b980cfd9c58c158b03020a2fdaf74fc928edb768"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9e96075909a085d87c06f9d5cd793495b87c7efc1badc6df4cfb313040dfe17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3538bb5ae2f7638960f1deddd745ab2f5cf9600091e0fd346743074dfb17924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e5d3a6dcadbc8f93f07d30c17b7330bf457f31d81a5b0db0e58ea282090fc75"
    sha256 cellar: :any_skip_relocation, ventura:        "01dd04f27e12ed6d4bfa3873911d947e6ae58b321e7b15bc26f9e19aa5a8dbba"
    sha256 cellar: :any_skip_relocation, monterey:       "b0486ae88054f871dd0a5b66a58ef41c2bfe2e27fa51e34fd40d1747495d935d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e8c6babff2e4b8821f98e4bef2e5f04c1f636edc1be2046ff54f31cfa1b0460"
    sha256                               x86_64_linux:   "aedaccb3daf5ae03c492773e9d405c28cf2e216147756a103b0b141f32d1f346"
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
