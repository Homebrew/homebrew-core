class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230828.67496e7.tar.gz"
  version "20230828"
  sha256 "22abca118e809008b6db14c2016ea6e42f977bbf44af16918382aa4fca1ed22f"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f7acf2aca54266ad4f3e1a4dece1470fc086e01bb58ac1f56ee6a41cd7ca4d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59489c08a95353c1c8351adbe7a2b39570271a7fd6322aea605f07cd34f643cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91d2b1844fa98421353cd6d51a4342b60f11c75d5b69a5186b305d5d582cb69d"
    sha256 cellar: :any_skip_relocation, ventura:        "9ac2ce7e9bed75d67f0f771467adae809a0d21610cb24281c21067e444e68e45"
    sha256 cellar: :any_skip_relocation, monterey:       "db1ec735dc1c45e4b1c0b7e56fc13d61e55536d30e8dfd3b5718ac48ec862f2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b0a99ae06cdf045519ed0f17e2f079d316ff79046887a5cd36a7b8a933ba232"
    sha256                               x86_64_linux:   "c929cd8a8562dda7f5eea6e2dfe4450cf335fcef1378998a5f6982f3228df226"
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
