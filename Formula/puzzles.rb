class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230612.1a316f4.tar.gz"
  version "20230612"
  sha256 "ba9d69a5e306d5d85b8c56391e95c814daecce83c85f3a2f624f3ae42b6c19a8"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a057adba5e84c26597c12f232291831a3090fd450441af7551287379e9108fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9954ff02acbca6a4737ab6e4036fe4535f1f816cf13309d20b4a735044216de2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65e4c97ab4b08e63d1834d4ecde828cbeb4d4f2c26f67b7eece86771fc91fd6b"
    sha256 cellar: :any_skip_relocation, ventura:        "3a15f4ea476e060854dd8c43fe33ff539871c7536b242a1918846abf21ec6158"
    sha256 cellar: :any_skip_relocation, monterey:       "b39c6d75e0c804aa9a1769190dc9f3c3700a5fa099f65252933be0d764172fbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfedd727062df8c78e40033c0ceb47551d0091ca86b93b91387f69fcbf814b76"
    sha256                               x86_64_linux:   "ea030eb2dc0267ab53d24727f084dd96e5632bbe58ac4655ddfcddef1d76f09d"
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
