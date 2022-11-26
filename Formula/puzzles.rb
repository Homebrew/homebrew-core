class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221126.a6a7997.tar.gz"
  version "20221126"
  sha256 "13bca2a3ce16fbdf9d415b704e106757598cac8bce590c4d1aa6743367ee5a50"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52b01b54de851cb5e487bcf6a94c4c6168c1e2c40789274868a1fd0dadec3b6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3430ba90eb8dc567255a19b9b01ae4563390db6fa676a726e13fb8d33f99a3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "964a29be93adf4f146a4bf5e44a8ddf059ec6da8e700667169fcad6cc5038e0a"
    sha256 cellar: :any_skip_relocation, monterey:       "42b47167280362d438cfe326f5fb837f22f50210222e5f05aaf27a0016555cbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4ff211d38fca114cfe673575f4c758535847d2b6813d9e89fb90b28476bbf1c"
    sha256 cellar: :any_skip_relocation, catalina:       "2465d64fe8e5e3f64a071877c6b136772465a289b1beda6b193ffd5bce579480"
    sha256                               x86_64_linux:   "5fad9cee8234bc7f6b89e413c372d64de21a64f6e784cd094bb863c7d4da51eb"
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
