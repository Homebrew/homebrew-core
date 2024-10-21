class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20241021.05f4f63.tar.gz"
  version "20241021"
  sha256 "ade66c07899a27fccddf5cff22a31bc7872bc0aaac169670cc123d6f755169c1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b01542e140bcd9308e6ce1dce6c13fe0ea1f462985df7e8b5713a320cc44aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dce511c34692d8c36c87f1a9528b9b0c74317792feed726ee01fb5b3f0d2edb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ff1edc85e7a291b78368529a70a16a7fde9d13975d31d83cda20e25e1093b1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "088ee3a655902618d7d91b6f36169ca1a8a181cf36e75027f10f987e6484249e"
    sha256 cellar: :any_skip_relocation, ventura:       "1c283c6266b7e15450b4497ab98ac77740a08221ad32e063000768ca6687269e"
    sha256                               x86_64_linux:  "730353885da9e60dc3d51e46155644e3fe88ffcb83513aadeaee1598d4248d7b"
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
