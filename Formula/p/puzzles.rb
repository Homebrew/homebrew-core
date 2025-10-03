class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250904.2376227.tar.gz"
  version "20250904"
  sha256 "145f91489a86321995e5049a34e06955e2204b98c071025f916d0cbdd5719cf2"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52a260608643882c7293dfac0399e4ae79c9d5e244c93c7fd4df03891cf51a36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "926d319ead9a6bb23e46d8fa737a4e46bb37176e84b8dc78c2c32b6290547916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e81ce6c817f6ce4b1394d4bf3166cbe4bb24e932a5fee15227f18a7694502ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6daa62e0cdfdd30a34ded0a2815e7f01d6b8300654a0a290c634a4a2ed9ad316"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e590cdd951d73304d7b66436a0fc5d95e28de68f13b63843ea318d41aaa9b53"
    sha256 cellar: :any_skip_relocation, ventura:       "2be4e89c857d65211c6a9b75ad4a27e005ce6ef871d5fda9492e8814e27985b0"
    sha256                               arm64_linux:   "d67a493f08484a51ce258d5124d6690e89d28bc566597f87f93700dfbe59bfc9"
    sha256                               x86_64_linux:  "7792d80ef04135951dcccc7d80358d1f7fa9d3f4aa0d7ae2471cc138f8f4027e"
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
