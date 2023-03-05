class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230305.fe40cda.tar.gz"
  version "20230305"
  sha256 "65a8634f0e30b35e2bb91a04cda3369e9d832ae069edc832c5dc0add354938f0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d650e62971e1f28b5b1d41b1ed2d123ccda212af1a3fe10957babb295e442c8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b235eb2185452ae1862209821fb49620fba71d2ab9d27c1391ab231747a1449"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50cff9b0f14046b37c4373cc5d40e738748edcfcf69603c4b58579a8eee2c79d"
    sha256 cellar: :any_skip_relocation, ventura:        "380d6880bb5c4d2f1f8d0c558faddcc6b64eadb026cc060ef368f8d55c62e68b"
    sha256 cellar: :any_skip_relocation, monterey:       "fa92773311bf31ca4637a215c51e4bcfae2fbc4def02875762006720e28581c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dd0448ecce005886e5d45a4612314e1dc3489f85b654c564929d314b42c68da"
    sha256                               x86_64_linux:   "48e1a2e586fcefd6d0a86a327323447ab2d109ee2cea778d0a56e88f8f12620b"
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

  conflicts_with "samba", because: "both install `net` binaries"

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
