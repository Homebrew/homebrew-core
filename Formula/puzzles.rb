class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221130.dbb2d2a.tar.gz"
  version "20221130"
  sha256 "e824c50e8c699aea356372c250366322849bbaf8fefcedc94b48d6c0134d1ec7"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c95f86e330aebcb8b418921653e1d623680fa2a4ccc15c3af8f1e4859be5c56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcde27b1f8c0caca71d707229dbe0fbe4ea385a1a538c4e6fc25f402ed7f1f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "449d561d1cc596c20a2e62e5494afde610b6a9cdeae042ba5a372d8b10f98b9a"
    sha256 cellar: :any_skip_relocation, ventura:        "a5952e1ec1cd6aa7f345bb223ed6577da0a399e4d985469e3553927a7294c60e"
    sha256 cellar: :any_skip_relocation, monterey:       "2c1e694c39f49132038d9e3d5a4e78e6e8621195dac49d7226427b4b266cea3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d644d3e9be7a0b146c91e4816ea82ab3792a0d2038b7210b3c362751bb84170b"
    sha256 cellar: :any_skip_relocation, catalina:       "05acad712bf3e9ceb288589e24d56ef6484c25ca72ca7868248f7e3d227a23f2"
    sha256                               x86_64_linux:   "24b7c99a52e4460f051b3748600d40b076de57b8eebb83b6f59d9e6b35a5e714"
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
