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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce9c9a5535f491319f91c4a41ac6cd3fd82855949aea1ae936e7580c6716fc85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "330345482d1c06ba9ce5abde9adf6d04f93c94bb322096d251f4c9537ccb8bf3"
    sha256 cellar: :any_skip_relocation, monterey:       "4371b1f66c09c97dd5ec74e8e4ee58ba0fa360484f029c1c00babab0c8368f01"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cab4b3dbbb6bd1c26f57d8909bdabd2114eb4b0332f7988020c47817f6410df"
    sha256 cellar: :any_skip_relocation, catalina:       "8343decd9db8f799a233de59715dd3878b1db579c8592f06dcfd167638fee921"
    sha256                               x86_64_linux:   "993c4cfae5f94404c97055f68133a23ec4df10cca3df647312dfb6bae4e59d76"
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
