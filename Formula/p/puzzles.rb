class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20260523.7ad37c6.tar.gz"
  version "20260523.7ad37c6"
  sha256 "3dc97cc025eb9e343af2332964c85672f2a21da9ea93579f31bcc66e3387ba97"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c26e9052eb912c010e5fe2c71f8491cc29d180803a7328d412ffa5ed22d3f6ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10e920c75ab714e2ff59ce1729bc372215f2191e6ea0d07a8ba75c8823daa4fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de126c7ba4eeb48609329f2e3a75e7f5304122c3d901e6b5a7a2c297a12de40d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d2a3077373df3bd7e89d09a86539c008d2571b6549b2f619ba4b9caa1220e09"
    sha256                               arm64_linux:   "ad36ad98e1a5bd204915bdef0edf6485a13bd3ac12882c5f7ada5f8c11575d9d"
    sha256                               x86_64_linux:  "e5ec400fb79d36fdb3f9096bae09797de028d9bab8a6e475031f323678764bbc"
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
