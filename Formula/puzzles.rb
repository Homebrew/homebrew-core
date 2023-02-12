class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230212.97b03cc.tar.gz"
  version "20230212"
  sha256 "c0b93a53b69080de99fc25107a5fff5b4a0b1e65d90bf2972a7ab08b07c8c471"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "951650b9fe3d3f8ac8dc18aef6f46e2dbc504331238c73300eea3a93523fa3f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d4a17ad8b2a3bd59e94f3039c79198992a65e7c2a2754267ab56270a7cdda8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0be8991aff4a7b49603f02acabbe0e15c52133dd550c2a57f563a8ed3862621"
    sha256 cellar: :any_skip_relocation, ventura:        "1a07641f204ea20bbf4213d46c42f9c8a61e567a6b2fec53d02c6e015ec7d29d"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb4ff28f00e643757d6eadb717216e7ab3b125228e2206679f333a5a35f0b04"
    sha256 cellar: :any_skip_relocation, big_sur:        "e393432dbe4b0ddd4e5f292dca3c85b3abb5efae6d1d5eed93e71953e84ecb66"
    sha256                               x86_64_linux:   "e1d92abcb574963a8275905e56e7ac14d02dda04a041d81356fe5fd94d065916"
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
