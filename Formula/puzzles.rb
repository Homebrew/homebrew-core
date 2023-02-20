class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230219.fccd2a5.tar.gz"
  version "20230219"
  sha256 "1e00bce068a78666793d95866bfb6f76c80b3de635f513933fd7ef6211d79ff2"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c78ed01371fea061be32040ac0b8876288c6066a4dc0a7da57a28210bacb028d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57e3dbc24799fa1484d58ae9bebc0724b52992f8659609d4e6312e9210ab696d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "527a845b396d3ead706b8088445a755a8382667f593ce34237ca66e98b446cb1"
    sha256 cellar: :any_skip_relocation, ventura:        "709a3d67fa3682ea4b87cdbb510bdbb31900799574e9472d73edda6a48316eec"
    sha256 cellar: :any_skip_relocation, monterey:       "ccc8b977c53234fb016b030b3897f2ab3bfeec87d9ae977fc9df3341235f96d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf873aa62c202b8242b15a8c6bf51ea65b653102641b85a7c26294160fc28024"
    sha256                               x86_64_linux:   "386ad5544cfed3960957964bdc32b360e6eba3e27b2f7df0f042250b6cd47b73"
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
