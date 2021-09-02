class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "9bc35bfaadfd51d45e3de6d3b5d6d484a3042773a10904cb1bf4c7562d834d77"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "3206f7d892bd1b7030aaad87456d38e792e7a4f1db6a1bf236812fb806fca966"
    sha256 big_sur:       "c3d97b3bb9d3ad6c5c71ea9b8db6af548d2f26d621f63d2fcb3b4500623deb14"
    sha256 catalina:      "631a30874cf16b202102fb0094b38e641f72554b9043277115b70ee8b449b7fe"
    sha256 mojave:        "7e5ba57cea44e6377410f50d119eb372656944e874fb1391efbce66e01fb6802"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on "ncurses"
  depends_on "readline"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output("#{bin}/notcurses-info", 1)
  end
end
