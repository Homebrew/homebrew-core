class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20220128.c43a34f.tar.gz"
  version "20220128"
  sha256 "4b1855c1b209f7534a73a49319668b071cec273db5b14e274b4909403a09d9b7"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cb08278a9c56ec786cf491586b6d61e64da5f949e399f8a521850eb9d97d342"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e275675cd3317ffb62a3f732a616a9cf5804bf7153d459c98dffbe17d1a68370"
    sha256 cellar: :any_skip_relocation, monterey:       "96afa8ad22ca624e61cdf94f1b41ee72ab65511227dd220431f4ef2e0eff9f24"
    sha256 cellar: :any_skip_relocation, big_sur:        "6069ee1bb9bbf6cd335188dbe9e74ab5b5459131218dcce315e0da1d63643b3d"
    sha256 cellar: :any_skip_relocation, catalina:       "c9c04fd4debab2bc34d2f0c77b39d57630f2a4cfc04c13c367dca44e089ec837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98ea7bc7167b2325d4b3b4cd2718b9b03aa6f27c48a8aba15a711d53db445f76"
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
