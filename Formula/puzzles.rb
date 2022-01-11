class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20220109.229d062.tar.gz"
  version "20220109"
  sha256 "daad329df79ee1dd43252e074c7e37188efd569d0205b50f807c77c66a1e09c2"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7372bb81f474b804b57d1b82289d0627a56407b2832f07265a4ad8e8483a99ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64a0c58cd6b3a4d29f3fe7e67e857b1ab3a9484678f67eccb26d26ceefbf49be"
    sha256 cellar: :any_skip_relocation, monterey:       "33cad9d3b818cc62e83df38f1a796b81192def7e7c542d7548f0e78811a20b10"
    sha256 cellar: :any_skip_relocation, big_sur:        "b340b40d55c443cb8acee6b84917d1f004d18aec3d5be6d95aa8a94051ca56cc"
    sha256 cellar: :any_skip_relocation, catalina:       "6dd263fd82480d43397af54e6c2bedcf9a5a6e6843be9e690b2f2b8ef504814d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bbd8921fbeff48f96283cc9bd931efe2d358516b88c7daff8cd7daa581c5573"
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
    on_macos do
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    end

    on_linux do
      # Gtk-WARNING **: 14:18:20.744: cannot open display
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
