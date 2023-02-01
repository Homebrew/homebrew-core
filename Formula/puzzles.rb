class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230201.37df1f2.tar.gz"
  version "20230201"
  sha256 "181f41fdf4b7d42ad6c8cdc760a641c72e9bcdbe5e1d2a64011bb3e815519c93"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ce8d2a713318f5ff651967289b6dc6cc1b551dfb7d4a5ef3c8c3aed3984b9eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8bc91325514ee6d219659769670cd1a8c8338e6ca5ae420ecc534b7ab2a44b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5a2394819781ee53dd04e4ea539eaba90b3a0eab647375522aa6cd4f1344c2f"
    sha256 cellar: :any_skip_relocation, ventura:        "f89e49da7d9768d09a24c9c67695bb3e0b13a8ec40352b6af8c3938562cdc736"
    sha256 cellar: :any_skip_relocation, monterey:       "ae9e9b47b4e0280e0850b51dd4dc3a68fdd76c212cdc02831a3a3e1e9ec0f394"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4277fbb3de19aa2e932206332c7233ff15f55b6fd7414778423686a9382eca6"
    sha256                               x86_64_linux:   "0370f280098a594f652d3494b64b440eee19a4445a88c98bdbcce571174b08bc"
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
