class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260720.3c36322.tar.gz"
  sha256 "cf43ae303f085c4a7b4c0711e3129755a9c689ebfbf3ea55bf273d9602223806"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8}(?:\.\h{7}+)?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2d4543e6354b7349a9b071de15587e52690f3abc5403eece616a2962e78e254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de09853d6b952785f08d8c2cb1c70f21eb5744869c412ad0cd22d2bc55b6a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d717eaf7a6499f2e982a4213ca6a2efb9a390e6119f64cc73d8933237da8f796"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bf7de1880220d661ec619849ae9164c42f869282af4e8c516a98fa319c1b51a"
    sha256                               arm64_linux:   "74fab0361cfb6d506bedabb8ec1321044182c921f6d827e3b4a5a381f8cd75bb"
    sha256                               x86_64_linux:  "7c4f27ec1b5eaa511e1d8a5873717bbc05997c0b0f4bba4b11e869b9b9f96ab1"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkgconf" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    # Disable universal binaries
    inreplace "cmake/platforms/osx.cmake", "set(CMAKE_OSX_ARCHITECTURES arm64 x86_64)", "" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
