class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250627.8314b03.tar.gz"
  version "20250627"
  sha256 "6afeee6fd1a723e57091319a7d207527d61f0a98d93acd9430a57270cbf35f02"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ba888aa86b8b40df6fd0cd5f91d4bed3c9a2abdd45dc4515e73b4aaaded8018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d002f940f7b2e0bbe52c357219bfebac5875ba10eb1a58d8aba3661d6f1a6733"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2490138d38a25f5d0b9917f0b7fcccfc4f5447e03c2f4915eb3f635bfdf94f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "b320973ba54f14dba3818ad5424b6c9e595b7609fe6308437e7b001e7bcce9ee"
    sha256 cellar: :any_skip_relocation, ventura:       "78eecf7aa3cac8dfe3617c25bfabf5b18e4d78c8cba6a4b161e76151266f82c9"
    sha256                               arm64_linux:   "6171f27dcf8ab860875128d46560af9b8a8a46ce673a88b23f57992275c4e57d"
    sha256                               x86_64_linux:  "2d9587689e6e10db3bb2ecf097d5695cd7ea0a835676882dbeb2674a8be2ec76"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkgconf" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
