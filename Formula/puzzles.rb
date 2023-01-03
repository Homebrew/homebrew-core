class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230103.2537961.tar.gz"
  version "20230103"
  sha256 "d55406e5339c0e72cdcf0bfa4047b6e6b25a83cbb901806cd78937ef3671e754"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "240ce4c83c8349a4c99145c61900b58e8dee19f224d2076e1ee7b63608be2399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c4788ec4bcfde0569281193249da656744fa5c0cefbbeda048d1568beabe0bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e71b6ee38800b56e3b5fcc7639144f4d98c6e0600eaddcb4a06a69d201ba9135"
    sha256 cellar: :any_skip_relocation, ventura:        "c9143de462f2c2b200048086792d3f06bbd67e1cabc726971c1949ac50dd597a"
    sha256 cellar: :any_skip_relocation, monterey:       "1f6fbf89c06cfb44f6fd35cc0c7fb409b8d1867909f0cb4b1ff14256dbfd9d01"
    sha256 cellar: :any_skip_relocation, big_sur:        "118c06461c41fda67f864cb848e8e58f9668746b7900a6823791e9affceb4217"
    sha256                               x86_64_linux:   "ded208f3b84468b30c23f808175367e3b2131eb15c8aeaaa7609c3146d85576c"
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
