class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20251127.a4f68b6.tar.gz"
  version "20251127.a4f68b6"
  sha256 "35a44ba2748c38a65a663b6d0439ccd95575a1adb5acb0c84af4b257c17db50d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "581690f135205b8574ee4974755bd0edeea91a57e8dfc938b4b48a70b7768189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37e04e06db429890f48973b09502f330c997d4c4510528c0da7fc6bb9c5bb8d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fffc0efc21b4464c5f78ccab95306369f39ea5886a25b0df6b5afec679d172c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "494bcc5206810a8f22cb619b3987403692c9c95c336b8ad7cb26f4e767010c40"
    sha256                               arm64_linux:   "c5180f035682b083278838f7c2970feca66532454ea5052b6df350ca5743b576"
    sha256                               x86_64_linux:  "146dddad3d99ef7ee1cdabf1f2a03878c716ddf96c37fd4840cddf3fd8729fd7"
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
