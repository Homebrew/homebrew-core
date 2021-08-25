class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.3.17.tar.gz"
  sha256 "81db9d13b515d01b134619f3e69cc1efe9f326030c4e49128131d3288ee68e33"

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
    # without the TERM definition, Notcurses is like a small child, lost in a
    # horrible mall. of course, if the tests are run in some non-xterm
    # environment, this choice might prove unfortunate.
    # you have no chance to survive. make your time.
    ENV["TERM"] = "xterm"
    assert_match "notcurses", shell_output("#{bin}/notcurses-info")
  end
end
