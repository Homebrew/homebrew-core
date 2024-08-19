class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240817.262f709.tar.gz"
  version "20240817"
  sha256 "e7bb3d2c1e0bec349bbe497fa9feed66e5ce5a6777ead8ad12c127fe407e26ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5917dad8e70fb73c2456fd518799230ac10ef7309e5290487f14d51f39f8113"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "448536d985ad1940356f418f4e41a20ff697f1ff9fbe87caa1431e2f3090c931"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fae2e6f25c2ca443a41ba420c809e8d7755b9627dd04bc9d4a5f10351351b02"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e2bc0d70a5731e72ec6516df368275eda409367eda5182de124985999426cd1"
    sha256 cellar: :any_skip_relocation, ventura:        "dc18115559b1329ce93584f6d786a70db346162ad1b3ff1638b23e41f009a575"
    sha256 cellar: :any_skip_relocation, monterey:       "f73488cbf8b11e07807b5d653c62bcbf24c2fa0138924d8357f890530b243454"
    sha256                               x86_64_linux:   "de0fba0ee7d7129324fa82a4ce9d433ba526885298b8fec43623fa88319e9f2c"
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
