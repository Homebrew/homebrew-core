class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230124.1f72a1a.tar.gz"
  version "20230124"
  sha256 "d1f30650212c434ddeb31c067db76d40a04086f82af1a39d275b5a719c863c9f"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6e14affb77e800fba7434b09a151ee6bcc7934ce86ce58ce1c4e78f49c2f271"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "026a2d9afd6742cec9717143803e87bf7d5fb0c9de5be7e299125e7f22031aa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbb0cc1ed91b00236ece3782723f675207e9b5902dee6888d9abfe93932695a0"
    sha256 cellar: :any_skip_relocation, ventura:        "77399ef25031a7eddf6935109ce88eb6f2a2ab9ae66d71a98563a076fa81cd66"
    sha256 cellar: :any_skip_relocation, monterey:       "598e94f2b88c13d3d6ccf6e46c8b614b9c419a4b9c70a7925b4b6e7ccfce77eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "10ce100cc40de48ec63f0e119f3cb437ebe949a3e073ffcb3252f3c065d3c06d"
    sha256                               x86_64_linux:   "ab28d95c57d69d85a8a0a5114434a7010739c293712c14f895699436f2abaf2c"
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
