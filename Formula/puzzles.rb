class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221022.0197ca4.tar.gz"
  version "20221022"
  sha256 "befa8ad93ede57414061dc4daa421ad6af40aa2e5ccfc5b5767c623c2e7d58ba"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27aa0af2f06d26e790b658e850325617b5b74edc4c069d39d1d7104c8f81887a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba08f0c077935991cf3c02fb2b8fad73cf3a2f91436bce88cd5728c2fe5e61df"
    sha256 cellar: :any_skip_relocation, monterey:       "cabe36b3184a7f9f48ce4b99541e5897636bbd3835a69796587a12c536f9586f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ab93da675daf628715623b4e650d69f4d4dcb9752a703f9447f51e1cd24e321"
    sha256 cellar: :any_skip_relocation, catalina:       "78ce0c072e52df56e1ebc87adfb108af598eba13a3aeaf09a099ed0eff3b4c4e"
    sha256                               x86_64_linux:   "62b2df7a70d1728126aa1005515f7113c923ff084bb3c6fce60b4be8b606be1f"
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
