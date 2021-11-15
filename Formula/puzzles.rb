class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20211031.640f923.tar.gz"
  version "20211031"
  sha256 "7562d65731d98b5d07d3bb5c0f5bf3704ea2279156ff41012a48e69d0f3d50cd"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5059bad798c405f1e6268af42b2c9c4f75ef64a5604cc3ab072c96ec4f0f901f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61f2053aa5f6794ef359d106120dfd954c5fd4ce4ef8f23b81f0092825aabd20"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2b5ced7280a325621b4abb3da7cdf58459fafc5aa80746197803ce69608382"
    sha256 cellar: :any_skip_relocation, big_sur:        "a097c3141b50047cce69fd444ca52c83d35f7b2c6484908f3200d2339261cf51"
    sha256 cellar: :any_skip_relocation, catalina:       "3a8b5fc472830793d11bfbcc0643b983a5bf31d151692fa77102013b91688ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09e61d6c7ca035c75d55ba06c22aa6a730d456d138fd904bcbcc7183c7a718df"
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
