class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240103.7a93ae5.tar.gz"
  version "20240103"
  sha256 "d694ebb9217e2a5d70a93148698607aef6c3f69fa4fb53c66b93e95788ef8049"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a581055dc8fc4c33fd0d43550783816f6c22a72513d36a2114d12335ef0fc661"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9e0ae453ce735312a662c665112e32b4d8d55b8eb0a8cd51556264ad56b3adf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d28be7257e999c3ef4df0ded85f8367c72603e6d3f0ea27517cad21e66ff2a96"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ca462db0f99f389c137b1131ae47042743b51e34dcb3c671c91f3f9474350cd"
    sha256 cellar: :any_skip_relocation, ventura:        "10a055c87ef2b977d85578f33f190df1ae916233145b9881e2f8a75876e78899"
    sha256 cellar: :any_skip_relocation, monterey:       "6a84a8f86288950c913f3d90ffc00482a1322661846a630fd34de59e50174a0d"
    sha256                               x86_64_linux:   "10a55de6d0f6c85421f126aaa28223f67cb167dc3a8d47e7854f730590da10ba"
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
