class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230214.5a0a2b9.tar.gz"
  version "20230214"
  sha256 "e2694038bb5a837366fa241b1aaf3bd7ebd997a84e75c8de466453ccaeca9743"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a780b3936a98425ab015874eca411e7b42c2a0c045d784d0746d836891be3480"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6376058258c519a959b3bb8145860b55f9045988a41136bc61c5a76fad24408a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5400356a66485c986bc5b2640391881d18a46b7d8ea8d663310b1de47a2e64c"
    sha256 cellar: :any_skip_relocation, ventura:        "58d5dbbeeb6879d121b7e9f627babfbcd097ed5bdefd486dcb47c3d793ec5359"
    sha256 cellar: :any_skip_relocation, monterey:       "406ff7a795d9462dc483857d80abc756c07dfd764cae2f280ffca8e1f19bb7ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "854c65a942684e954e9f5a2d8d70203fe10b80b8c514b4a5e488536fc8732900"
    sha256                               x86_64_linux:   "54d5c6711fa697de9d1f16d44a88a188a54a9767b0046d58edf310a98a3a0068"
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
