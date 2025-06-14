class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20250613.47bd72c.tar.gz"
  version "20250613"
  sha256 "5e411a6697a54607f5414041f957d2feb418599328e7023f9e0783e3891e3b0d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "869e40e4415d9a3e4f7aa315e4f338768c108f870dc6efd629ba1188428bb406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11d3b9044148ada16ff47ea19995584edfe2dd4813531372124c11cd3d089692"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8cbc19821903c4ba59fd939b269f6e3d175d084ba05c3d5dd1e9c60d14f0fcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ca6bafcdd00772f34b5ef3c89007e40c4b7ed977d262e2c1a6d2c83ed1d8a31"
    sha256 cellar: :any_skip_relocation, ventura:       "ef67cf16510a2845f6dee5f75bc026c3b3f0cf14794b5c68211d1b97173dcc9f"
    sha256                               arm64_linux:   "e3c369f29ca87ccda01b1dd7c9d16dc19d88a463b4fcfa225239b4263afd8dcc"
    sha256                               x86_64_linux:  "5df0a7233a33a81c5fbeb51f4b98edeabd59bfc54f1d428ca9e087f34eddd670"
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
