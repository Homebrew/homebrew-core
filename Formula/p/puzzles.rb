class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230918.2d9e414.tar.gz"
  version "20230918"
  sha256 "62cbc9ff90d37af45bfac0b159cfca703d97e485f0017bd61957e892bd3a9d43"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39d4d7a3f2a7a0834147c7f932bd369ecb9ca3d124ab2b43e23a5a9299e8a9de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98597ae9954f150fafd3b5f529d89929419e7ea1322dd2eb9936bf06445db29a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea31bbc3a2181387972d942a31fd297518fecd1f7c4f80558ad9f0c49c91fd82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a3a642e6cb708b30bba79f71b9ecaa957d787a5ca417ceb6dd02afcec3e390b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2915be0f56dae7d1189549232a5dbfbeb4bb4a7b5f368325c58d4b0bbc8e08b8"
    sha256 cellar: :any_skip_relocation, ventura:        "adf1d4d5ad90925b8584d395b209ba082b6984baa184db7e3f98857de8cc8f07"
    sha256 cellar: :any_skip_relocation, monterey:       "515ee9cc3fb8179db37d5ef0d48b87b74ccf7bff23d04da551c7ba0b3940773d"
    sha256 cellar: :any_skip_relocation, big_sur:        "63465f1f32f8a73a016824f8366de587b742950cc1deeda07f54ba95422e48d7"
    sha256                               x86_64_linux:   "bee7e00b4bcbeb7a091f68845bfd6e8926ee2372b06bfd8b6104f885f599cf3d"
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
