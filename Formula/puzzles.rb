class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20221102.289342e.tar.gz"
  version "20221102"
  sha256 "76a5c15b26383a5b0c8de8f7336c9fea60431189cc66da52f9cf800c8ab6c3d1"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96cc4262cf1e0bd7dc20776ba2b3bac9a09f8a0d777c037e865715ba4cb95c0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d415f96c790cdf0883cfbe501e666e139486500d3459cf1b3c2a065d8138a12d"
    sha256 cellar: :any_skip_relocation, monterey:       "e7d8492cc506bada0a7a6c3032eae8f1cfcfffaf7b06936dbab4b4acda77bddd"
    sha256 cellar: :any_skip_relocation, big_sur:        "96ff6ee9643de6acad944f432676812c5445014efe127f7db70ff3a9b9830be9"
    sha256 cellar: :any_skip_relocation, catalina:       "0a8affed0fb4324064ffd6cf39bcd6e1c6d402c51e3be1df7e5519eef68e983b"
    sha256                               x86_64_linux:   "05d7d3dceee4660e38a4866a3d3e267bdf19dee136c107df510b9c58cdd76a03"
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
