class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20251120.28032bd.tar.gz"
  version "20251120"
  sha256 "683e043aeaae5298ed98a54297320a6cefba2c3d93defaa04837fb0ffc0f62b1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aa0576678f33bdb1f52c06ed6fd379226301502245410163c146c0ec60802ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed93f9ee813105ca9631e466dfaaf20cd43ce459fac8e7c8f7f75dfdd5bb96f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "345899030b411ca8c2420048f111403d8662c3ab3784a6550562b89eb7272197"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a88685740b0658d0b5b92fac258b31c63a96362f50df15840b1903252f22a9"
    sha256                               arm64_linux:   "a39596f1ff1e276ea88429bf5f5d18744d445cdfc65bff88b0908d318751f9a6"
    sha256                               x86_64_linux:  "9affe9937cfd72ebc978cbf575e41c1c8f31afa552f6c5b9ebe8466e9491c235"
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
    # Disable universal binaries
    inreplace "cmake/platforms/osx.cmake", "set(CMAKE_OSX_ARCHITECTURES arm64 x86_64)", "" if OS.mac?

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
