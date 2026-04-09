class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260309.06e37f1.tar.gz"
  version "20260309.06e37f1"
  sha256 "dd9fd0a7c0ffd037892fda1994a2fabf1f415ef31515ae8c327912b5db3f5472"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e85e6d58bd4c2f1c420317b03c6e743b9bdee51ebdab48dd1051c3d81d4544ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23e8c86a9d0d5bb70d08bef88a532da67446de4dfa69c0a9a8f52484d67f7c09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ce574c0e4db685a6a2ead9b733f996bfdc8165388add10a0893b03e2c94aa1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eee5cd07eef054ebf82c06b14e459baf26f0b7ba92f89beef48af12adcd8002"
    sha256                               arm64_linux:   "d676ccb89c0750938128e9ee328ae14225d78ab45144265bc819ada7254c229a"
    sha256                               x86_64_linux:  "1a9a163635a5b878e33b55196a5a69d094d01081a9d77855fc948e8b64d8a50e"
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
