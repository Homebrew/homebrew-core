class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230220.1235f05.tar.gz"
  version "20230220"
  sha256 "6dff2d083f4969087cca9ce41dc855db79bc4745cb29d289cec825a3d9d8a426"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89ad3d318a99460f9f1cefccc80968eb1c5c8a22a083be4272a0ff5645ed90d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5e3b6d7cf9e6dda07f42c25d2d4efd437af83e80375bcd179a02f2e028ee8f2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd6f4a8a06d6f48068513659fe62cf45b953ccc00ed70237b88bbacce0bda75d"
    sha256 cellar: :any_skip_relocation, ventura:        "0ff82229633326e85a63119549a84feb206b338d81f004457df914d9db7bfeda"
    sha256 cellar: :any_skip_relocation, monterey:       "5e44b3077382d6d10d0e53c9663344553d12971aef1a36b7c6c2d778dccab2d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b94ab9371cd8646d657b5216f50fa73225b8768d09df5210d0ae87705a278fd"
    sha256                               x86_64_linux:   "cdc2fe6d05f89979afeccd1b0981c78cc6920b7987124330848f6cd23026f26e"
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
