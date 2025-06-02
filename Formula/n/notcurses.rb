class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.16.tar.gz"
  sha256 "e893c507eab2183b6c598a8071f2a695efa9e4de4b7f7819a457d4b579bacf05"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "84131b1243f2e5549bb6447676154e3fdc89645af7878da42bb95db1e18a48cd"
    sha256 arm64_sonoma:  "05b2fab227b9544777d87743dad78203723d947a11620770fea5e323ebd30ce0"
    sha256 arm64_ventura: "2471d064f62373e83af6e105491d0b8d36a5f8acd178d52fe981a1d57dc096b4"
    sha256 sonoma:        "f7e722cc893f7f1bfb9c4e83b5cabb3894767edfae89718a290c45fbc2c21032"
    sha256 ventura:       "669e599e85ff4d89808b791fd3d001420e3f65526be3a278fabb0c2e9d46d94a"
    sha256 arm64_linux:   "9029a9ffcb2f68d1f374df14b553ffb72cc9f613ed3a13b84916559838c44471"
    sha256 x86_64_linux:  "f8861705f6f75c3ae9ce526d5fe1a3268ab72d6b31c185a31bfb91580cfeec7c"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output(bin/"notcurses-info", 1)
  end
end
