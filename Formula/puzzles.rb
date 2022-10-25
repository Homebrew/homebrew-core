class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221024.a62217e.tar.gz"
  version "20221024"
  sha256 "49dc162bf2af29090a526508fa2d971c2ad504a8f9a84632a95aa5a5d3a0c169"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9e7440969ae903aa21a9c0341f57f0c9ad54c4bc66650d6ee74de92907c54ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e602e7d478bf500ec5ff90d4e3cea793fe04fd41cfeb886e49a88f614153272d"
    sha256 cellar: :any_skip_relocation, monterey:       "fdfe0486a7e785791d1622af7f3c6353c0690db444ad6d5caa5ffe5910316a6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "25c2c6fef0cbbc0339cdf1f2b0ab9cc3c45c228c8a598b50318c91b73b8faed2"
    sha256 cellar: :any_skip_relocation, catalina:       "94eaa25b07862aa7934a9b74a0a80493cdec69ba1cec8ffc5ce5dd9eda2d4f6f"
    sha256                               x86_64_linux:   "e5849786accd301369e6fb1b0b230bc813e551fd86709b0502c0f05d1c97f9f4"
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
