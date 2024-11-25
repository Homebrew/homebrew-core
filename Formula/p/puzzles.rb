class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20241123.5e74004.tar.gz"
  version "20241123"
  sha256 "afdeab416ab6509a0ba0807ec35c5cc48bdde64346198abe5ab8bf5688de6f44"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0b33a7fcc44fc2f0aeacff18c0651f6d91093ad1e786f5c372f78519a6402e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcbd3e7a038c306bf37195b2bf9db17d9e32dacde0f6c66cdadc46e120689d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ae709ab14af5d25d2fdf25f183ac1c5683689a9e53f13126d9d9d760c3400fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2486bf8da086a82d9ecc22b7e71c2b8a34a989e1298f684d85c585a4355fb4d"
    sha256 cellar: :any_skip_relocation, ventura:       "fc6cba933f62613496ac5089292e002b0a39c0dc1e887ff95098fccbb2fc2513"
    sha256                               x86_64_linux:  "26c258a90f7e260f6d9c5cf2b9f9477945ecfde088a52d3d990ea8ce3cf24863"
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
