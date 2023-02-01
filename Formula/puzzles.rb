class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230201.37df1f2.tar.gz"
  version "20230201"
  sha256 "181f41fdf4b7d42ad6c8cdc760a641c72e9bcdbe5e1d2a64011bb3e815519c93"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f896587dd18bc20aa6c0c2f99cf4c00484126ca195426f17623d6ecafe1e92e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a415b000b8cb7bbe92a05b44db6907f6a4273b6fadc9d5c8fe9005f2855345b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a1ef36cc5eb754e5f210149184ed3e1c7a03aba41f690555676f0a6ec8adf3f"
    sha256 cellar: :any_skip_relocation, ventura:        "cb3930df18d30fb38fda9b534e2f146616ea6466ee59acd2597a409a00304b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "85faa6591c3e3fe21c7f82bf6eed05a9f16996a9cd2f3c5ed197b9924c27b504"
    sha256 cellar: :any_skip_relocation, big_sur:        "288d7603927e6d6dad7df8102962e6084e232dfa70754f4b459313966b5d0368"
    sha256                               x86_64_linux:   "afd23a3a84384895bca246d4b898860afbf9f7b8d639fcb475cbba7e5403a6d8"
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
