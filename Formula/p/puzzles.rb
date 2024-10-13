class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240928.182b3d9.tar.gz"
  version "20240928"
  sha256 "0f831d79cee1ecc3c6f964ad0c36a9ce358b89a2d6cea6ce8a999f594a64edb0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b765acc865f61138e9896c202990537c8e6fa101e8802568a656a9d420a69f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "897d5f6ab98af2e925c90ac668c4e5852812c0b19a3f11efe0d663efc014acb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f24a5d8e56dfa5f9f2e3f3808c35ee86dfc2d9112a3ce2fbdffccd02a8b4feb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccb1b2df454e99dc436364b38a7d5e443c06cba5449a7e065fe8fc8aa6fc176e"
    sha256 cellar: :any_skip_relocation, ventura:       "e537319cac31e9685ad7240f9db6abfb116caaf6bdf2866b85744df069c2638f"
    sha256                               x86_64_linux:  "9d01edc697a1f942c1376125cb8bfb16cc1cc2517102c0b23af54ba7412d84e4"
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
