class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260905.a683d27.tar.gz"
  version "20260905.a683d27"
  sha256 "35fc636858e6aaeb9a9a883420ce9a7e5516c1a04e168e5666c28ec72c5b6e4b"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8}(?:\.\h{7}+)?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9db305bfd68df9c2c6c447496749e3d82e77c4bdfe6b6cb167ec8d881c42e5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6070328c2a9db2098d216285d51489c3f32cb7844b5233b8baf7a028241c933"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeb20aa42b6b52078927ffeddc0f5dfcee621d599b7f4246dbf02522d5877f98"
    sha256                               arm64_linux:   "be9efd2f45ba2b48d3d74469e5fb2f4f1b5bc53f8ff7279a2d38c6e0e9e2b081"
    sha256                               x86_64_linux:  "48cb0a0cec4cc20a1f3d45b7f591315596c53c1d416cd66eae0e7d93aa3150a1"
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
