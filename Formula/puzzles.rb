class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20210526.8f3413c.tar.gz"
  version "20210526"
  sha256 "6c075a6ae2ab4131281fe07278d4daac6e9363142b65325f60cbf0660b532225"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d086cbc56f4e840c2bd336078b1f7a0c99c396844445aa77a6aa2544278bec8f"
    sha256 cellar: :any_skip_relocation, big_sur:       "07de30b3ea4890d3877dbb9e6a0041fb25bbe67d2cfc437d1dd69769cdac915d"
    sha256 cellar: :any_skip_relocation, catalina:      "dd80a3fd46c2167b3159e9e8d39157c2a3938d67a04426418cd15b69ce058d7a"
    sha256 cellar: :any_skip_relocation, mojave:        "82cd3f20a6e75482caef19754884c61c9fc8e6ba8bec8d23dc401cc721631007"
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

    on_macos do
      bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles"
    end
  end

  test do
    on_macos do
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    end

    on_linux do
      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
