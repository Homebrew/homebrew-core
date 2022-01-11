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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a7ccfcc7c7c3b8637f28ee44f7e18e205a406b0fe14350446f1de6bba9d8b44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac169cb29494e627f535cd80b1f009bf68112b9c32b462a711014244fd1c80d4"
    sha256 cellar: :any_skip_relocation, monterey:       "6ad0e1cd8f2071d06e2b595dc2d0f7d462caebc6d05b78767e53c761c612809e"
    sha256 cellar: :any_skip_relocation, big_sur:        "87a5a23ad60845347d86db32e8b4cd7a5420bb1184361cf70189abbed78b688a"
    sha256 cellar: :any_skip_relocation, catalina:       "459df65d6086983b9ae7cef731125c3bd304f5546820b1f298f889a7455f20de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b02279146483133e45f23c2bf2e0e00b81352aa31eaf40e08e3e426d15f5318"
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
