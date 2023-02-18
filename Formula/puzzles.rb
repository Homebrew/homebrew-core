class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230218.3a3e491.tar.gz"
  version "20230218"
  sha256 "9486cdd8f1a4a42485ff9dea3b7e3716c3dc2e59bb3f1c2e5a45bb09441d1460"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d97377eb7d8d998f45d7df3220e1f7fd7b5f3ca8174d6b79ac005939c0cfb4fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d1ebfe6bf40a3fe92c54c77f62d0ac4a96814cb8886be9a4b94c22276246ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20a65c4c9d28c30c8dd3f2ab017b64e0ae637c9fc6734d59999396925d0d415b"
    sha256 cellar: :any_skip_relocation, ventura:        "71116433b422533062bf0002654fb249742e7e2ba7709ddbc3753b0fee282150"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e37874b8fb021260a25ef7186625bbc19dc73ddc5b0e9ab82c459acb116edf"
    sha256 cellar: :any_skip_relocation, big_sur:        "95d6d47486d14af51b7c0df42dd377071c9bd2b2b91143ec81ecab54afa7e2a8"
    sha256                               x86_64_linux:   "eba9ade8593f1665e8c2f39c6898ffc61ca817aba3dad090ba07b9aced442226"
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
