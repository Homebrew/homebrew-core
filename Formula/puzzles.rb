class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221119.f86623b.tar.gz"
  version "20221119"
  sha256 "11e7a20e67a7cb4a96310e0a712b71149d2963e14f18825b7aaecbc5291ad170"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99c81b2faf8af57b9003e8f3f380b4f39e19c43b932cc7bd1bec9f84e3da48dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "805e2bf4e51345ebf313fa6c322b609914935681864aa5e63d78e4168af51945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4366d698a8c76c3ff140da8cb5164d84f1745d82149a9caa2b671cb72fcb8de8"
    sha256 cellar: :any_skip_relocation, monterey:       "cff8cfa381c1e55609b39a3fe2bc64406e659268bbd848f45396b2bc71b79bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bad1b2ca546435212059e2ceeaefc8693ccdf302a2db1202fc781f5c32e3c9e"
    sha256 cellar: :any_skip_relocation, catalina:       "267e937ca74e3f5cbbc60356a1abd6e157f3ff7f4450e10e68078fef1b6b69c8"
    sha256                               x86_64_linux:   "6d597ab19cff6fa5fc47d9ee197f4ad0fe2a8c939c8861acac3b57cb0a338a24"
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
