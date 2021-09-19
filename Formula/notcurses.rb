class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "982fc662f7239cff6713ce0f17f1db7c76a3de1644196438de6bb276bec65704"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "b9d7e032bc3b18b283a505d899e177c5d3c3d6c9a7ba924a53ddc49aca3b4bd4"
    sha256 big_sur:       "b58b4340122f6edfd62469597482790b32ebe44c0a30b3e1a5477ab207edca0e"
    sha256 catalina:      "8d781d154b2d9dcf3afa2531efaebd3d520bf66dd42baabdbbe038b4d0d741f2"
    sha256 mojave:        "cb43c7acb9f65f35bb251bfbe605c06f69f9e4de56bf91bc285fe7357c89b075"
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

  fails_with gcc: "5"

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
